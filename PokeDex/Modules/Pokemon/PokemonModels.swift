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
            let currentPage: Int?
        }
        
        struct ViewModel {
            let pokemon: [Pokemon]
        }
        
        struct Header {
            let displayTitle: String
            let backgroundImage: Image
        }
    }
}
