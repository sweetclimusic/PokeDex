//
//  PokemonSceneView.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 20/01/2025.
//
import SwiftUI

protocol PokeApiPokemonDisplayLogic: AnyObject {
    func displayViewContents(
        viewModel: PokeDex.ViewContents.ViewModel
    )
}

protocol PokeApiPokemonViewDelegate: AnyObject {
    func displaySelectedPokemon(for url: String)
    func navigateToPokedex()
    func navigateToBackView()
}

extension PokeDex {

    public enum SceneState: String, Equatable {
        case loading
        case empty
        case error
        case noConnection
        case summary
    }

    struct SceneView: View {
        @Namespace var nspace

        @State var observableState: ObservableState

        @State private var path = NavigationPath()
        @State var pokemonData = [PokeDex.PokeApi.Pokemon]()
        var body: some View {
            NavigationStack(path: $path) {
                ScrollView {
                    renderView(viewState: observableState.viewState)
                }
                .ignoresSafeArea(.container, edges: .bottom)
                .navigationBarTitleDisplayMode(.large)
                .task {
                    if observableState.viewState != .summary {
                        await loadPokemonData()
                    }
                }
            }.padding(.horizontal)
        }

        fileprivate func loadPokemonData(_ offset: Int? = nil, _ limit: Int? = nil) async {
            observableState.viewState = .loading
            do {
                //pokemonData = try await interactor.refreshPokemonData()
                if let result = try await
                observableState.interactor?.getViewContents(
                    offset: offset, limit: limit) {
                    observableState.viewModel = result
                }
                pokemonData = observableState.viewModel.pokemon
            } catch {
                observableState.viewState = .error
            }
        }

        @ViewBuilder
        public func renderView(viewState: SceneState) -> some View {
            switch viewState {
            case .loading:
                LoadingView()
            case .empty:
                NoContentView()
            case .error:
                ErrorView {
                    Task {
                        await loadPokemonData(observableState.viewModel.currentPage)
                    }
                }
            case .noConnection:
                NoInternetView() {
                    Task {
                        await loadPokemonData(observableState.viewModel.currentPage)
                    }
                }
            case .summary:
                PokedexView(
                    pokemonData: self.$pokemonData, path: $path, observableState: observableState
                )
            }
        }
    }
}
