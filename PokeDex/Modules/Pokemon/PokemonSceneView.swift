//
//  PokemonSceneView.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 20/01/2025.
//
import SwiftUI

protocol PokeApiPokemonDisplayLogic: AnyObject {
    func displayViewContents(
        viewModel: PokeApi.Pokemon.ViewContents.ViewModel
    )
}

protocol PokeApiPokemonViewDelegate: AnyObject {
    func displaySelectedPokemon(for url: String)
    func navigateToPokedex()
    func navigateToBackView()
}

extension PokeApi.Pokemon {

    public enum SceneState: String, Equatable {
        case loading
        case empty
        case error
        case noConnection
        case summary
    }

    struct SceneView: View {
        var interactor: PokeApiPokemonBusinessLogic!
        var observableState: ObservableState = ObservableState()
        
        @State private var path = NavigationPath()

        var body: some View {
            NavigationStack(path: $path) {
                ScrollView {
                    AnyView(renderView(viewState: observableState.viewState))
                }
                .navigationBarTitleDisplayMode(.large)
                .task {
                    await interactor.getViewContents()
                }
            }.padding()
        }

        @ViewBuilder
        public func renderView(viewState: SceneState) -> any View {
            switch viewState {
            case .loading:
                LoadingView()
            case .empty:
                NoContentView()
            case .error:
                ErrorView()
            case .noConnection:
                NoInternetView()
            case .summary:
                PokedexView()
            }
        }
    }
}
