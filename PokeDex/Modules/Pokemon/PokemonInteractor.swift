//
//  PokemonInteractor.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 21/01/2025.
//
import Foundation
import SwiftUI

protocol PokeApiPokemonBusinessLogic {
    func getViewContents(offset: Int?, limit: Int?) async throws
    -> PokeDex.ViewContents.ViewModel
    func loadmorePokemonData(offset: Int?, limit: Int?) async
    -> [PokeDex.PokeApi.Pokemon]
    func refreshPokemonData() async
    -> [PokeDex.PokeApi.Pokemon]
}

protocol PokeApiPokemonDataStore {
    var selectedPokemon: PokeDex.PokeApi.Pokemon? { get set }
    var nextPage: Int? { get set }
    var previousPage: Int? { get set }
    var pokemonData: [PokeDex.PokeApi.Pokemon] { get set }
}

extension PokeDex {
    typealias Response = ViewContents.Response
    
    class Interactor: PokeApiPokemonBusinessLogic, PokeApiPokemonDataStore {
        
        var nextPage: Int?
        
        var previousPage: Int?
        
        var selectedPokemon: PokeDex.PokeApi.Pokemon?
        
        var pokemonData: [PokeDex.PokeApi.Pokemon] = []
        
        private var pokeApiGetService: any PokeApiGetService
        private var currentPage: Int = 0
        private var currentLimit: Int = 20
        
        var presenter: PokeApiPokemonPresentationLogic!
        
        init(_ usingService: any PokeApiGetService) {
            pokeApiGetService = usingService
        }
        
        func getViewContents(offset: Int?, limit: Int?) async throws
        -> ViewModel
        {
//        var pokemonPagedResults: [Pokemon]
        var pokemonDetails: PokeDex.PokeApi.Pokemon?
        var viewModel: PokeDex.ViewContents.ViewModel!
        do {
            // First task: Get the pokemon list
            currentPage = offset ?? currentPage
            currentLimit = limit ?? currentLimit
            
            
            viewModel = try await withThrowingTaskGroup(
                of: PokeDex.PokeApi.Pokemon.self, returning: ViewModel.self
            ) { group in
                let pokemonPagedResults = try await pokeApiGetService.get(
                    page: currentPage,
                    limit: currentLimit
                ).compactMap { $0 as? PokeDex.PokeApi.Pokemon }
                
                // Second task: Get specific pokemon details
                var results: [PokeDex.PokeApi.Pokemon] = []
                for pokemon in pokemonPagedResults {
                    guard let pokId = pokemon.id
                    else { continue }
                    group.addTask {
                        try await self.pokeApiGetService.get(by: pokId) as! PokeDex.PokeApi.Pokemon
                    }
                }
                
                // Process results with debug logging
                for try await result in group {
                    pokemonDetails = result
                    results.append(result)
                }
                // Ensure data is available
                if results.count == 0, pokemonDetails == nil {
                    throw PokeAPIEndpointError.notFoundError
                }
                results.sort { $0.id! < $1.id! }
                previousPage = max(0, currentPage - currentLimit)
                currentPage += currentLimit
                nextPage = currentPage + currentLimit
                // we would re-render the view in traditional Clean swift, but using Async/Await and Task to redraw to the screen
                // return the builtup ViewModel
                viewModel = presenter.presentViewContents(
                    response: Response(
                        selectedPokemon: pokemonDetails,
                        results: results,
                        currentPage: currentPage,
                        nextPage: nextPage,
                        previousPage: previousPage
                    )
                )
                pokemonData = results
                return viewModel
            }
            
        } catch {
            let response = Response(
                selectedPokemon: nil,
                results: [],
                currentPage: currentPage,
                nextPage: nextPage,
                previousPage: previousPage
            )
            if let pokeApiError = error as? PokeAPIEndpointError,
               pokeApiError == .noInternetError
            {
            print(
                "❌ Failed to get pokemon details with, error: \(error.localizedDescription)"
            )
            return presenter.presentError(
                response: response,
                errorType: PokeAPIEndpointError.noInternetError)
            } else {
                print(
                    "❌ Failed to get pokemon details, unknownError"
                )
                return presenter.presentError(
                    response: response,
                    errorType: PokeAPIEndpointError.unknownError)
            }
        }
        
        return viewModel
        }
        
        func refreshPokemonData() async -> [PokeDex.PokeApi.Pokemon] {
            var viewModel: PokeDex.ViewContents.ViewModel!
            do {
                //get all fetch data so far, consider prevPage number and currentPage number
                //assume we started at 0 and see how far ahead currentPage is eg.. 60 then let limit = currentPage
                //and offset will be 0.  if prev page is nil or zero lets get the current page and current limit
                let offset = 0
                let limit = currentPage - offset
                
                viewModel = try await self.getViewContents(
                    offset: offset, limit: limit)
                pokemonData = viewModel.pokemon
                // update what to fetch next since we refreshed the data
                currentLimit = 20  // reset to default
                previousPage = max(0, currentPage - currentLimit)
                currentPage = limit
                nextPage = currentPage + currentLimit
            } catch {
                return []
            }
            return pokemonData
        }
        
        func loadmorePokemonData(offset: Int? = nil, limit: Int? = nil) async -> [PokeDex.PokeApi.Pokemon] {
            var viewModel: PokeDex.ViewContents.ViewModel!
            do {
                viewModel = try await getViewContents(offset: offset, limit: limit)
            } catch {
                return []
            }
            return viewModel.pokemon
        }
    }
    
}
