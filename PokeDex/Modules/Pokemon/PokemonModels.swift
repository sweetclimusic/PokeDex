//
//  PokemonModels.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 21/01/2025.
//
import Foundation
import SwiftUI

extension PokeApi.Pokemon {
    enum ViewContents {
        
        struct Response {
            let selectedPokemon: Pokemon?
            let results: [Pokemon]
            let currentPage: Int?
            let nextPage: Int?
            let previousPage: Int?
        }
        
        struct ViewModel {
            let pokemon: [Pokemon]
            // MARK: pagination
            let currentPage: Int
            let nextPage: Int?
            let previousPage: Int?
        }
        
        
        struct Header {
            let displayTitle: String
            let backgroundImage: Image
        }
    }
}
