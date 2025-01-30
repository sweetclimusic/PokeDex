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
        -> PokeApi.Pokemon.ViewContents.ViewModel
    func loadmorePokemonData(offset: Int?, limit: Int?) async
        -> [Pokemon]
    func refreshPokemonData() async
        -> [Pokemon]
}

protocol PokeApiPokemonDataStore {
    var selectedPokemon: Pokemon? { get set }
    var nextPage: Int? { get set }
    var previousPage: Int? { get set }
    var pokemonData: [Pokemon] { get set }
}

extension PokeApi.Pokemon {
    typealias Response = PokeApi.Pokemon.ViewContents.Response

    class Interactor: PokeApiPokemonBusinessLogic, PokeApiPokemonDataStore {

        var nextPage: Int?

        var previousPage: Int?

        var selectedPokemon: Pokemon?

        var pokemonData = [Pokemon]()

        private let pokeApiGetService = Container.shared.getpokeApiGetService()
        private var currentPage: Int = 0
        private var currentLimit: Int = 20

        var presenter: PokeApiPokemonPresentationLogic!

        func getViewContents(offset: Int?, limit: Int?) async throws
            -> PokeApi.Pokemon.ViewContents.ViewModel
        {
            var pokemonPagedResults: [Pokemon]
            var pokemonDetails: Pokemon?
            var viewModel: PokeApi.Pokemon.ViewContents.ViewModel!
            do {
                // First task: Get the pokemon list
                currentPage = offset ?? currentPage
                currentLimit = limit ?? currentLimit

                pokemonPagedResults = try await pokeApiGetService.get(
                    page: currentPage,
                    limit: currentLimit
                )

                try await withThrowingTaskGroup(of: Any.self) { group in
                    // Second task: Get specific pokemon details
                    group.addTask { [weak self] in
                        var results: [Pokemon] = []
                        for pokemon in pokemonPagedResults {
                            guard let pokId = pokemon.id,
                                let details = try await self?.pokeApiGetService.get(by: pokId)
                            else {
                                print("❌ Failed to get pokemon details")
                                continue
                            }
                            results.append(details)
                        }
                        return results as Any
                    }

                    // Process results with debug logging
                    for try await result in group {

                        if let detail = result as? Pokemon {
                            pokemonDetails = detail
                            
                        } else if let pokeResults = result as? [Pokemon] {
                            pokemonPagedResults = pokeResults
                            previousPage = max(0, currentPage - currentLimit)
                            currentPage += currentLimit
                            nextPage = currentPage + currentLimit
                        } else {
                            print("❌ Unknown result type:", result)
                        }
                    }
                    // we would re-render the view in traditional Clean swift, but using Async/Await and Task to redraw to the screen
                    // return the builtup ViewModel
                    viewModel = presenter.presentViewContents(
                        response: Response(
                            selectedPokemon: pokemonDetails,
                            results: pokemonPagedResults,
                            currentPage: currentPage,
                            nextPage: nextPage,
                            previousPage: previousPage
                        )
                    )
                    pokemonData = pokemonPagedResults
                }
                // Ensure data is available
                if pokemonPagedResults.count == 0, pokemonDetails == nil {
                    throw PokeAPIEndpointError.notFoundError
                }

            } catch {
                throw PokeAPIEndpointError.unknownError
            }

            return viewModel
        }

        func refreshPokemonData() async -> [Pokemon] {
            var viewModel: PokeApi.Pokemon.ViewContents.ViewModel!
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
                currentLimit = 20 // reset to default
                previousPage = max(0, currentPage - currentLimit)
                currentPage = limit
                nextPage = currentPage + currentLimit
            } catch {
                return []
            }
            return pokemonData
        }

        func loadmorePokemonData(offset: Int? = nil, limit: Int? = nil) async -> [Pokemon] {
            var viewModel: PokeApi.Pokemon.ViewContents.ViewModel!
            do {
                viewModel = try await getViewContents(offset: offset, limit: limit)
            } catch {
                return []
            }
            return viewModel.pokemon
        }
    }

}
