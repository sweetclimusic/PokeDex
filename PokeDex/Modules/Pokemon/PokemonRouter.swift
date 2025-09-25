//
//  PokemonRouter.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 22/01/2025.
//

import Foundation
import SwiftUI

extension PokeDex {
    class Router: Displayable {
        
        var viewType: any View.Type {
            PokeDex.SceneView.self
        }
        
        var dataStore: PokeApiPokemonDataStore!
        var sceneViewState: SceneState = PokeDex.SceneState.empty
        private var _interactor: Interactor?
        var interactor: Interactor {
            get {
                if _interactor == nil {
                    if ProcessInfo.processInfo.environment["XCODE_TEST_PLAN_NAME"] == "PokeDexUITests" {
                        Container.shared.pokemonService = MockPokemonApiService()
                        
                    } else {
                        Container.shared.pokemonService = PokemonService()
                    }
                    
                    _interactor = Interactor(Container.shared.getpokeApiGetService())
                }
                return _interactor!
            }
            set {
                _interactor = newValue
            }
        }
        
        func contentView() -> any View {
            if ProcessInfo.processInfo.environment["XCODE_TEST_PLAN_NAME"] == "PokeDexTests" {
                VStack {
                    Text("System under Testing")
                }
            } else {
                display() as? PokeDex.SceneView
            }
        }
        
        func display() -> any View {
            let observableSceneState = PokeDex.ObservableState()
            let interactor = self.interactor
            let presenter = Presenter(observableState: observableSceneState)
            
            interactor.presenter = presenter
            
            observableSceneState.viewState = sceneViewState
            observableSceneState.interactor = interactor
            dataStore = interactor
            
            return PokeDex.SceneView(observableState: observableSceneState)
        }
    }
}
