//
//  ObservableState.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 21/01/2025.
//

import SwiftUI

extension PokeApi.Pokemon {
    @Observable class ObservableState {
        public var viewState: SceneState = .empty
        public var viewModel: ViewModel = ViewModel(
            pokemon: [],
            currentPage: 0,
            nextPage: nil,
            previousPage: nil
        )
        public var interactor: PokeApiPokemonBusinessLogic?
    }
}
