//
//  SceneCoordinator.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 21/01/2025.
//

extension PokeApi.Pokemon {
    class ViewController: PokeApiPokemonDisplayLogic{
        
        func displayViewContents(viewModel: PokeApi.Pokemon.ViewContents.ViewModel) {
            //PokeApi.Pokemon.Router().display()
        }
        
        
        private var observableState: ObservableState
        var router: Router!
        
        init(observableState: ObservableState) {
            self.observableState = observableState
        }
        
        func displaySelectedPokemon(for url: String) {
            // Update the observable state when a pokemon is selected
            Task {
                observableState.viewState = .loading
                // Additional logic to fetch pokemon details
                observableState.viewState = .summary
            }
        }
        
        func navigateToPokedex() {
            observableState.viewState = .summary
        }
        
        func navigateToBackView() {
            // Handle navigation back
            // You might want to use a navigation path here
            observableState.viewState = .summary
        }
    }
}
