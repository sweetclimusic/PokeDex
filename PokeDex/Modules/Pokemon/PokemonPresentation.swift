//
//  PokemonInteractor.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 21/01/2025.
//
import Foundation
import SwiftUI

protocol PokeApiPokemonPresentationLogic {
    func presentError(
        response: PokeDex.ViewContents.Response,
        errorType: PokeAPIEndpointError
    ) -> PokeDex.ViewContents.ViewModel
    
    func presentViewContents(
        response: PokeDex.ViewContents.Response
    ) -> PokeDex.ViewContents.ViewModel
}

extension PokeDex {
    typealias ViewModel = PokeDex.ViewContents.ViewModel
    class Presenter: PokeApiPokemonPresentationLogic {
        private weak var observableState: ObservableState!
        
        init(observableState: ObservableState!) {
            self.observableState = observableState
        }
        
        let builder = PokeDex.ViewModelBuilder()
        
        func presentViewContents(response: PokeDex.ViewContents.Response) -> ViewModel {
            let viewModel = builder.buildPokemonViewModel(pokeResponse: response)
            observableState.viewModel = viewModel
            observableState.viewState = .summary
            
            return viewModel
        }
        
        func presentError(response: PokeDex.ViewContents.Response, errorType: PokeAPIEndpointError = .unknownError) -> ViewModel {
            let viewModel: ViewModel = builder.buildPokemonViewModel(pokeResponse: response)
            observableState.viewModel = viewModel
            switch errorType {
            case .unknownError, .badRequestError, .notFoundError:
                observableState.viewState = .error
            case .noInternetError:
                observableState.viewState = .noConnection
            }
            return viewModel
        }
        
    }
    
}
