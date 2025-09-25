//
//  PokemonView.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 21/01/2025.
//

import SwiftUI

extension PokeDex {
    static let verticalSpacing: CGFloat = 10.0
    struct PokemonView: View {
        @Namespace var nspace
        @Environment(\.dismiss) private var dismiss
        var pokemon: PokeDex.PokeApi.Pokemon
        @Binding var path: NavigationPath
            
        // Testing Helper for viewInspect
        internal let inspection = Inspection<Self>()
        var body: some View {
            ZStack {
                VStack(alignment: .center, spacing: verticalSpacing) {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Text(pokemon.name?.uppercased() ?? "")
                                .font(.largeTitle)
                                .modifier(TextEffectModifier(color: .white))
                                .matchedGeometryEffect(
                                    id: pokemon.id, in: nspace, properties: .position)
                        }
                    }

                    AsyncImage(url: URL(string: pokemon.imageUrl ?? "")) { phase in
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
                    .frame(width: 300, height: 300)
                    .clipped()
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Divider()
                        Text("TYPE")
                            .font(.title)
                            .modifier(TextEffectModifier(color: .black))
                            .padding(.horizontal, 25)
                        HStack {
                            Text(pokemon.primaryType?.uppercased() ?? "unknown")
                                .font(.title3)
                                .modifier(TextEffectModifier(color: .purple))
                            Spacer()
                            Text(pokemon.secondaryType?.uppercased() ?? "")
                                .font(.title3)
                                .modifier(TextEffectModifier(color: .purple))
                        }
                        .padding(.horizontal, 25)
                        Divider()
                    }
                    .padding(.horizontal, 0)
                    .padding(.vertical, 25)
                    .background(
                        Color.white
                    )
                    
                }
                .safeAreaInset(edge: .bottom) {
                    VStack(alignment: /*@START_MENU_TOKEN@*/ .center /*@END_MENU_TOKEN@*/) {

                        Button(
                            role: .cancel,
                            action: {
                                dismiss()
                            }
                        ) {
                            Image(systemName: "xmark")
                        }
                        .buttonStyle(
                            CircleButtonStyle(color: .purple)
                        )
                    }
                    .safeAreaPadding(.vertical, 5)
                }
            }
            .background(
                Image("ForestBG")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 300, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
                    
            )
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }
}
