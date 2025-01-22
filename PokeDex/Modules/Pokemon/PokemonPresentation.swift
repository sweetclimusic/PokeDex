//
//  PokemonInteractor.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 21/01/2025.
//
import Foundation
import SwiftUI

protocol PokeApiPokemonPresentationLogic {
    func presentViewContents(response: PokeApi.Pokemon.ViewContents.Response)
}

extension PokeApi.Pokemon {
    class Presenter: PokeApiPokemonPresentationLogic {
        weak var sceneView: PokeApiPokemonDisplayLogic!

        let builder = PokeApi.Pokemon.ViewModelBuilder()
        func presentViewContents(response: PokeApi.Pokemon.ViewContents.Response){
            builder.buildAPokemonHabitat()
            sceneView.displayViewContents(viewModel: .init(pokemon: []))
        }
 
    }

}
