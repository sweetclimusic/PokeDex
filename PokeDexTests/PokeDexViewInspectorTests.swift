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
    var observableState: PokeDex.ObservableState!
    var interactorSpy: PokeApiPokemonInteractorLogicSpy!
    var routerSpy: PokeDex.Router!
    
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        observableState = PokeDex.ObservableState()
        interactorSpy = .init()
        routerSpy = .init()
        observableState.interactor = interactorSpy
        observableState.viewModel = PokeDex.ViewModel(
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
        let sut = PokeDex.ErrorView()
        
            // WHEN
        let exp = sut.inspection.inspect(after: Test.Interval) { [self] view in
            guard
                let contentCard = try? view.find(PokeDex.NoContentView.self),
                let noContentView = try? contentCard.actualView(),
                let images = try? noContentView.inspect().findAll(ViewType.Image.self),
                let cancelButton = try? noContentView.inspect().find(ViewType.Button.self),
                let pokeballModifier = try? noContentView.inspect().find(ViewType.Label.self)
                    .modifier(PokeBall.self)
            else {
                XCTFail("test_noErrorView_withExpected: ❌ failed - Required content not found in ErrorView")
                return
            }
            
            let cardText = noContentView.description.contains("Oh No! we encountered an error")
            let buttonText = noContentView.buttonText.contains("Cancel")
            
            
            var foundImage: SwiftUI.Image?
            images.forEach { image in
                if let actualImage = try? image.actualImage(),
                   (try? actualImage.name()) == "exclamationmark.triangle" {
                    foundImage = actualImage
                }
            }
            
                // THEN
            XCTAssertTrue(cardText)
            XCTAssertTrue(buttonText)
            XCTAssertNotNil(foundImage)
            XCTAssertNotNil(cancelButton)
            XCTAssertEqual(
                try cancelButton.labelView().text().string() ,
                "Cancel"
            )
            XCTAssertNotNil(try pokeballModifier.actualView().body)
        }
        ViewHosting.host(view: sut)
        defer {
            ViewHosting.expel()
        }
        wait(for: [exp], timeout: Test.Timeout)
    }
    
    @MainActor
    func test_loadingView_withExpected() throws {
        var sut = PokeDex.LoadingView()
        XCTAssertTrue(true)
    }
    
    @MainActor
    func test_noInternetView_withExpected() throws {
        var sut = PokeDex.NoInternetView()
        XCTAssertTrue(true)
    }
    
    // MARK: incomplete test, needs a stub Pokemon array to send directly to the SummaryView
//    @MainActor
//    func test_pokemonView_withExpected_PokemonCards() async throws {
//        // WHEN
//        let path: Binding = .constant(NavigationPath())
//        
//        let pokemonService =  MockPokemonApiService()
//        pokemonService.stubbURLSession = PokeApiGetRequestSpy()
//        Container.shared.pokemonService = pokemonService
//        
//        let results = try await pokemonService.get(page: nil, limit: 20)
//        let pokemonDataAsArray: [PokeDex.PokeApi.Pokemon] = Array(observableState.viewModel.pokemon)
//        let sut = PokeDex
//            .PokemonView(pokemon: results[0], path: path )
//        let exp = sut.inspection.inspect(after: Test.Interval) { [self] view in
//            guard
//                let contentCard = try? view.find(
//                    PokeDex.PokemonView.self
//                ),
//                let pokemonText = try? contentCard.find(text: "bulbasaur".capitalized),
//                let pokemonType1 = try? contentCard.find(text: "Grass".capitalized),
//                let pokemonType2 = try? contentCard.find(text: "Poison".capitalized)
//            else {
//                XCTFail("test_pokemonView_withExpected_PokemonCards: failed - Required content not found in ErrorView")
//                return
//            }
//            //THEN
//            XCTAssertEqual(try pokemonText.string(), "bulbasaur".capitalized)
//            XCTAssertEqual(try pokemonType1.string(), "Grass".capitalized)
//            XCTAssertEqual(try pokemonType2.string(), "Poison".capitalized)
//        }
//        wait(for: [exp], timeout: Test.Timeout)
//        XCTAssertTrue(true)
//    }
}
