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
            var observableSceneState = PokeApi.Pokemon.ObservableState()
            observableSceneState.viewState = sceneViewState
            
            let interactor = Interactor()
            let presenter = Presenter()
            let viewController = ViewController(observableState: observableSceneState)
            interactor.presenter = presenter
            
            dataStore = interactor
            var sceneView = PokeApi.Pokemon.SceneView(interactor: interactor,observableState: observableSceneState)
        
            presenter.sceneView = viewController
            return sceneView
        }
    }
}
