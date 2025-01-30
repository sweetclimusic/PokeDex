//
//  PokemonInteractor.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 21/01/2025.
//
import Foundation
import SwiftUI

protocol PokeApiPokemonPresentationLogic {
    func presentViewContents(response: PokeApi.Pokemon.ViewContents.Response) -> PokeApi.Pokemon.ViewContents.ViewModel
}

extension PokeApi.Pokemon {
    typealias ViewModel = PokeApi.Pokemon.ViewContents.ViewModel
    class Presenter: PokeApiPokemonPresentationLogic {
        private weak var observableState: ObservableState!
        
        init(observableState: ObservableState!) {
            self.observableState = observableState
        }
        
        let builder = PokeApi.Pokemon.ViewModelBuilder()
        
        func presentViewContents(response: PokeApi.Pokemon.ViewContents.Response) -> ViewModel{
            let viewModel = builder.buildPokemonViewModel(pokeResponse: response)
            observableState.viewModel = viewModel
            observableState.viewState = .summary
            
            return viewModel
        }
        
    }
    
}
