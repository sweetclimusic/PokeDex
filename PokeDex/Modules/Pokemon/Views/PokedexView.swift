//
//  Pokedex.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 21/01/2025.
//

import SwiftUI

extension PokeApi.Pokemon {
    struct PokedexView: View {
        @Namespace var nspace
        var body: some View {
            Text("Hello, Pokedex")
                .matchedGeometryEffect(id: 0, in: nspace, properties: .position)
        }
    }
}
