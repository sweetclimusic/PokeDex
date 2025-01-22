//
//  RootView.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 19/01/2025.
//

import SwiftUI

struct RootView: View {
    @State private var searchString: String = ""
    var body: some View {
        Text("PokéDex list here")
            .padding()
            .frame(width: 300,height: 300)
            .modifier(CardBackground())
            .searchable(
                text: $searchString,
                prompt: Text("Search for Pokémon")
            )
    }
}

#Preview {
    RootView()
}
