//
//  PokedexCell.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 29/01/2025.
//
import SwiftUI
extension PokeApi.Pokemon {
    struct PokedexCell: View {
        @Namespace var nspace
        @State var pokemon: Pokemon
        var body: some View {
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: verticalSpacing) {
                    VStack(alignment: .leading, spacing: verticalSpacing) {
                        AsyncImage(url: URL(string: pokemon.imageUrl ?? "")) { phase in
                            switch phase {
                            case .failure:
                                Image(systemName: "wifi.slash")
                                    .modifier(PokeBall())
                            case .empty:
                                ProgressView()
                                    .frame(width: 150, height: 150)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 150)
                            default:
                                EmptyView()
                            }
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("#\(String(format: "%03d", pokemon.id ?? 0))")
                            .font(.largeTitle)
                            .modifier(TextEffectModifier(color: .primary))
                            .frame(width: 100, alignment: .topTrailing)
                    }
                }
                Spacer()
                HStack(alignment: .bottom) {
                    Text(pokemon.name?.uppercased() ?? "unknown")
                        .font(.title2)
                        .modifier(TextEffectModifier(color: .primary))
                        .matchedGeometryEffect(
                            id: pokemon.id, in: nspace, properties: .position)
                }
            }
        }
    }
}
