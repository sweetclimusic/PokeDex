//
//  PokemonRouter.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 22/01/2025.
//

import Foundation
import SwiftUI

extension PokeApi.Pokemon {
    class Router: Displayable {

        var viewType: any View.Type {
            PokeApi.Pokemon.SceneView.self
        }

        var dataStore: PokeApiPokemonDataStore!

        var sceneViewState: SceneState = PokeApi.Pokemon.SceneState.empty

        func display() -> any View {
            let observableSceneState = PokeApi.Pokemon.ObservableState()
            let interactor = Interactor()
            let presenter = Presenter(observableState: observableSceneState)
            
            interactor.presenter = presenter

            observableSceneState.viewState = sceneViewState
            observableSceneState.interactor = interactor
            dataStore = interactor

            return PokeApi.Pokemon.SceneView(
                interactor: interactor, observableState: observableSceneState)
        }
    }
}
