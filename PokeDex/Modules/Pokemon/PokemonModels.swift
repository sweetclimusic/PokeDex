//
//  PokemonModels.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 21/01/2025.
//
import Foundation
import SwiftUI

extension PokeDex {
    enum ViewContents {
        
        struct Response {
            let selectedPokemon: PokeDex.PokeApi.Pokemon?
            let results: [PokeDex.PokeApi.Pokemon]
            let currentPage: Int?
            let nextPage: Int?
            let previousPage: Int?
        }
        
        struct ViewModel {
            let pokemon: [PokeDex.PokeApi.Pokemon]
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
