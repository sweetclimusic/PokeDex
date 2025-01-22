//
//  Factory.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 21/01/2025.
//

import Foundation

extension Container {
    struct shared {
//        private static var pokemonGetService: PokeApiGetService
        private static var pokemonService: PokemonService?
        // I've left this in to show a design of DI, but I needed further endpoints that are specific to my model design
//        static func getpokeApiGetService() -> any PokeApiGetService {
        static func getpokeApiGetService() -> PokemonService {
            if pokemonService == nil {
                pokemonService = PokemonService()
            }
            return pokemonService!
        }
    }
}
