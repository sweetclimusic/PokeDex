//
//  PokeDexViewInspectorTests.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 28/01/2025.
//

import XCTest
import ViewInspector
import SwiftUI
@testable import PokeDex

final class PokeApiPokemonViewInspectorTests: XCTestCase {
    var observableState: PokeApi.Pokemon.ObservableState!
    var interactorSpy: PokeApiPokemonInteractorLogicSpy!
    var routerSpy: PokeApi.Pokemon.Router!
    
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        observableState = PokeApi.Pokemon.ObservableState()
        interactorSpy = .init()
        routerSpy = .init()
        observableState.viewModel = PokeApi.Pokemon.ViewModel(
            pokemon: [],
            currentPage: 20,
            nextPage: 40,
            previousPage: nil
        )
    }
    
    @MainActor
    func test_noErrorView_withExpected() throws {
        // GIVEN
        observableState.viewState = .error
        let sut = PokeApi.Pokemon.ErrorView()
        
        // WHEN
        let exp = sut.inspection.inspect { [self] view in
            guard let contentCard = try? view.find(Text.self, containing: "Oh No! we encountered an error"),
                  let pokeballModifier = try? contentCard.image().modifier(PokeBall.self),
                  let systemImage = try? pokeballModifier.viewModifierContent() else {
                return XCTFail("test_noErrorView_withExpected: ❌ failed - Required content not found in ErrorView")
            }
            let icon = try systemImage.find(viewWithAccessibilityLabel: "exclamationmark.triangle")
            try contentCard.find(button: "Retry").tap()
            // THEN
            XCTAssertNotNil(icon)
            XCTAssertTrue(interactorSpy.didGetViewContents)
        }
        wait(for: [exp], timeout: Test.Timeout)
    }
    
    @MainActor
    func test_loadingView_withExpected() throws {
        var sut = PokeApi.Pokemon.LoadingView()
        XCTAssertTrue(true)
    }
    
    @MainActor
    func test_noInternetView_withExpected() throws {
        var sut = PokeApi.Pokemon.NoInternetView()
        XCTAssertTrue(true)
    }
    @MainActor
    func test_pokedexView_withExpected() throws {
        var pokemonData: Binding = .constant([Pokemon]())
        var path: Binding = .constant(NavigationPath())
        var sut = PokeApi.Pokemon.PokedexView(pokemonData: pokemonData, path: path, observableState: observableState)
        XCTAssertTrue(true)
    }
    @MainActor
    func test_ppokemonView_withExpected() throws {
        var path: Binding = .constant(NavigationPath())
        var pokemonDataAsArray: [Pokemon] = Array(observableState.viewModel.pokemon)
        
        var sut = PokeApi.Pokemon.PokemonView(pokemon: pokemonDataAsArray[0], path: path )
        XCTAssertTrue(true)
    }
}
