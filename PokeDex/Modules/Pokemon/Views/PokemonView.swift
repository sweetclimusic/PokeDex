//
//  PokemonView.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 21/01/2025.
//

import SwiftUI

extension PokeApi.Pokemon {
    struct PokemonView: View {
        @Namespace var nspace
        
        var pokemon: Pokemon
        @Binding var path: [Int]
        
        var body: some View {
            VStack {
                Spacer()
                Text(pokemon.name ?? "")
                    .matchedGeometryEffect(id: 0, in: nspace, properties: .position)
                AsyncImage(url: URL(string: pokemon.imageUrl!)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    default:
                        EmptyView()
                    }
                }
                .frame(width: 200, height: 100)
                .clipped()
                .padding(10)
                .background(.ultraThinMaterial)
                .border(Color.gray)
                VStack(alignment: .leading) {
                    Text("Type")
                        .font(.title3)
                    HStack {
                        Text(pokemon.primaryType ?? "unknown")
                        Spacer()
                        Text(pokemon.secondaryType ?? "unknown")
                    }
                }
            }.safeAreaInset(edge: .bottom) {
                // MARK: extract View to buttonView, destination "ChartView()" actual...
                // MARK: ...detail view with specified object defined in KMP
                    VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                        
                        Button(role: .cancel, action: {path.removeAll()})
                        {
                            Image(systemName: "xmark")
                        }
                        .buttonStyle(
                            CircleButtonStyle(color: .purple)
                        )
                    }
                    .safeAreaPadding(.vertical, 5)
                }
        }
    }
}
