//
//  PokemonInteractor.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 21/01/2025.
//
import Foundation
import SwiftUI

protocol PokeApiPokemonBusinessLogic {
    func getViewContents()
}

protocol PokeApiPokemonDataStore {
    var selectedPokemon: String? { get set }
    var currentPage: Int? { get set }
    var pokemonHabitat: [PokemonHabitat] { get set }
}

extension PokeApi.Pokemon {
    class Interactor: PokeApiPokemonBusinessLogic, PokeApiPokemonDataStore {
        
        var selectedPokemon: String?
        var currentPage: Int? = 0
        var pokemonHabitat: [PokemonHabitat] = []

        var pokemon = [Pokemon]()

        private let pokeApiGetService = Container.shared.getpokeApiGetService()
        var presenter: PokeApiPokemonPresentationLogic!

        func getViewContents() {
            Task {
                if let data = try await pokeApiGetService.get(page: 0) as? [Pokemon] {
                    pokemon = data
                    presenter.presentViewContents(
                        response: .init(selectedPokemon: nil, currentPage: currentPage)
                    )
                }
            }
        }
    }

}
