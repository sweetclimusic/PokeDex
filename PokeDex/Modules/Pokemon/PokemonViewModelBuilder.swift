//
//  PokemonViewModelBuilder.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 21/01/2025.
//

extension PokeDex {
    class ViewModelBuilder {
        func buildPokemonViewModel(pokeResponse: Response) -> ViewModel {
            //manipulate the data here pokemon, habitat, image and build a viewmodel
            .init(
                pokemon: pokeResponse.results,
                currentPage: pokeResponse.currentPage ?? 20,
                nextPage: pokeResponse.nextPage,
                previousPage: pokeResponse.previousPage
            )
        }
    }
}
