//
//  Pokedex.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 21/01/2025.
//

import SwiftUI

extension PokeDex {
    struct PokedexView: View {
        @Namespace var nspace
        
        @Binding var pokemonData: [PokeDex.PokeApi.Pokemon]
        @Binding var path: NavigationPath
        @State private var searchText: String = ""
        @State private var searchIsActive = false
        @State private var currentPokemonID: Int?
        let observableState: ObservableState
        // testing helper for viewInspect
        internal let inspection = Inspection<Self>()
        var body: some View {
            ScrollViewReader { proxy in
                List(searchResults, id: \.id) { pokemon in
                    ScrollView {
                        Spacer()
                        NavigationLink(
                            destination: PokemonView(pokemon: pokemon, path: $path)
                        ) {
                            PokedexCell(pokemon: pokemon)
                                .onAppear {
                                    currentPokemonID = pokemon.id
                                }
                        }
                        .buttonStyle(.plain)
                        .navigationTransition(.zoom(sourceID: pokemon.id, in: nspace))
                        .task {
                            if pokemonData.last?.id == pokemon.id {
                                // Fetch and Filter out existing Pokemon
                                let newPokemonData =
                                await observableState.interactor?.loadmorePokemonData(
                                    offset:  pokemonData.count, //observableState.viewModel.currentPage,
                                    limit: 20
                                ).filter { newPoke in
                                    !pokemonData.contains(where: { $0.id == newPoke.id })
                                } ?? []
                                pokemonData += newPokemonData
                            }
                        }
                        
                    }
                    .onReceive(
                        inspection.notice
                    ) {
                        self.inspection.visit(self, $0)
                    }
                }.refreshable {
                    pokemonData =
                    await observableState.interactor?.refreshPokemonData() ?? []
                }
                .scrollIndicators(.hidden)
//                .listRowInsets(EdgeInsets.init(top: 0, leading: 8, bottom: 0, trailing: 8))
                .frame(minHeight: 1000)
                .listStyle(.plain)
                .navigationTitle("PokéDex")
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: $searchText, isPresented: $searchIsActive)
                .onChange(of: searchIsActive) { _, newValue in
                    if !newValue, let currentId = currentPokemonID {
                        if let index = pokemonData.firstIndex(where: { $0.id == currentId }) {
                            withAnimation {
                                proxy.scrollTo(currentId, anchor: .center)
                            }
                        }
                    }
                }
            }
        }
        
        var searchResults: [PokeDex.PokeApi.Pokemon] {
            if searchText.isEmpty {
                return Array(pokemonData)
            } else {
                let result = pokemonData.filter { pokemon in
                    guard let name = pokemon.name else {
                        return false
                    }
                    return name.localizedCaseInsensitiveContains(searchText)
                }
                return Array(result)
            }
        }
        
        var getPokeMonData: [PokeDex.PokeApi.Pokemon] {
            return Array(pokemonData)
        }
    }
}
