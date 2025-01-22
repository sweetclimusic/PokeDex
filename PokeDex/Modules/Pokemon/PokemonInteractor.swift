//
//  PokemonInteractor.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 21/01/2025.
//
import Foundation
import SwiftUI

protocol PokeApiPokemonBusinessLogic {
    func getViewContents() async throws
}

protocol PokeApiPokemonDataStore {
    var selectedPokemon: String? { get set }
    var nextPage: Int? { get set }
    var previousPage: Int? { get set }
    var pokemonSpeciesQueried: [PokeApiStandardResultNode] { get set }
}

extension PokeApi.Pokemon {
    class Interactor: PokeApiPokemonBusinessLogic, PokeApiPokemonDataStore {
        var nextPage: Int?
        
        var previousPage: Int?
        
        var pokemonSpeciesQueried: [PokeApiStandardResultNode] = []
        
        var selectedPokemon: String?
        
        var pokemon = [Pokemon]()
        
        private let pokeApiGetService = Container.shared.getpokeApiGetService()
        private var currentPage: Int = 0
        var presenter: PokeApiPokemonPresentationLogic!
        
        func getViewContents() async throws {
            var pokemonDetails: Pokemon?
            var pages: [String] = []
            do {
                try await withThrowingTaskGroup(of: Any.self) { group in
                    group.addTask { [weak self] in
                        //fetch pokemon page
                        return try await self?.pokeApiGetService.get(page: self?.currentPage) as Any
                    }
                    group.addTask { [weak self] in
                        return try await self?.pokeApiGetService.get(by: 35) as Any
                    }
                    // Process the results
                    for try await result in group {
                        if let details = result as? Pokemon {
                            pokemonDetails = details
                        } else if let pokeResults = result as? PokemonSpecies {
                            // capture the previous and next query offsets
                            if let next = pokeResults.next {
                                pages.append(next)
                            }
                            if let previous = pokeResults.previous {
                                pages.append(previous)
                            }
                            
                        }
                    }
                }
                // Ensure data is available
                guard let details = pokemonDetails,
                      let imageUrlString = details.imageUrl,
                      let imageUrl = URL(string: imageUrlString) else {
                    throw PokeAPIEndpointError.notFoundError
                }
                
                presenter.presentViewContents(
                    response: .init(selectedPokemon: nil, currentPage: currentPage)
                )
            }
        }
    }
    
}
