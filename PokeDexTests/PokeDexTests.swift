//
//  PokeDexTests.swift
//  PokeDexTests
//
//  Created by Ashlee Muscroft on 19/01/2025.
//

import XCTest
@testable import PokeDex
import SwiftUI

final class PokeDexTests: XCTestCase {
    let observableSut = PokeDex.ObservableState()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        observableSut.viewState = .empty
        observableSut.viewModel = PokeDex.ViewModel(
            pokemon: [],
            currentPage: 20,
            nextPage: nil,
            previousPage: nil
        )
    }
    
    func test_pokemonType_decoderWithExpected () throws {
        let bulbasaurData = Test.getBulbasaurJSON()
        let expectedImageURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"
        do {
            let decoder = JSONDecoder()
            let pokemonTypes = try decoder.decode(PokeDex.PokeApi.Pokemon.self, from: bulbasaurData)
            XCTAssertEqual(pokemonTypes.imageUrl, expectedImageURL)
            XCTAssertEqual(pokemonTypes.id, 1)
            XCTAssertEqual(pokemonTypes.name, "bulbasaur")
            XCTAssertEqual(pokemonTypes.primaryType, "grass")
            XCTAssertEqual(pokemonTypes.secondaryType, "poison")
        }
    }
    // MARK: incomplete test, the sut SceneView how(?) to activate the task in the sceneview(?) would need a delegate and then can test the delegate or remove the `fileprivate` from loadPokemonData
//    func test_getContentsForPokemon_SumaryView() async throws {
//        // WHEN
//        let pokemonSpyResult = PokeApiGetRequestSpy()
//        pokemonSpyResult.stubbedFetchedData = Test.getBulbasaurJSON()
//
//        let spyInteractor = PokeApiPokemonInteractorLogicSpy()
//        let spyObservable = PokeDex.ObservableState()
//        spyObservable.interactor = spyInteractor
//        spyObservable.viewModel = PokeDex.ViewModel(
//            pokemon: [.init(id: 1, name: "bulbasaur")],
//            currentPage: 20,
//            nextPage: nil,
//            previousPage: nil
//        )
//        let sut = PokeDex.SceneView(
//            observableState: spyObservable
//        )
//        
//        XCTAssertTrue(spyInteractor.didGetViewContents)
//        XCTAssertEqual(spyInteractor.getViewContentsCount, 1)
//        XCTAssertNotNil(spyObservable.viewModel.pokemon[0])
//    }
    
    func test_PokemonService_get_success() async throws {
        // GIVEN
        let pokemonSpyResult = PokeApiGetRequestSpy()
        pokemonSpyResult.stubbedFetchedData = Test.getBulbasaurJSON()
        let presenterSpy = PokeApiPokemonPresentorLogicSpy()
        presenterSpy.studdedPresentViewContentsResponse = .init(
            pokemon: [.init(id: 1, name: "bulbasaur")],
            currentPage: 0,
            nextPage: nil,
            previousPage: nil
        )
        
        let pokemonService = MockPokemonApiService()
        
        pokemonService.stubbPokemon = .init(id: 1, name: "bulbasaur")
        // WHEN
        let sut = PokeDex.Interactor(pokemonService)
        sut.presenter = presenterSpy
        
        // THEN
        do {
            let viewModel = try await sut.getViewContents(offset: nil, limit: 20)
            let pokemonResult = try XCTUnwrap(viewModel.pokemon.first)
            let response = try XCTUnwrap(
                presenterSpy.presentViewContentsParameters?.0
            ) as PokeDex.ViewContents.Response
            XCTAssertEqual(pokemonResult.id, 1)
            XCTAssertEqual(pokemonResult.name, "bulbasaur")
            
            XCTAssertEqual(
                presenterSpy.didPresentViewContentsCalledCount,
                1
            )
            XCTAssertTrue(presenterSpy.didPresentViewContentsCalled)
            XCTAssertEqual(
                response.results[0],
                viewModel.pokemon[0]
            )
        }
        catch {
            XCTFail(error.localizedDescription + "#file \(#file) #line \(#line) in test_PokemonService_get_success()")
        }
    }

}
