//
//  Factory.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 21/01/2025.
//

import Foundation

extension Container {
    struct shared {
        public static var pokemonService: (any PokeApiGetService)?
        static func getpokeApiGetService() -> any PokeApiGetService {
            if pokemonService == nil {
                pokemonService =  PokemonService()
            }
            return pokemonService!
        }
    }
}
