//
//  PokeDexTests.swift
//  PokeDexTests
//
//  Created by Ashlee Muscroft on 19/01/2025.
//

import XCTest
@testable import PokeDex

final class PokeDexTests: XCTestCase {
    let observableSut = PokeApi.Pokemon.ObservableState()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        observableSut.viewState = .empty
        observableSut.viewModel = PokeApi.Pokemon.ViewModel(
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
            let pokemonTypes = try decoder.decode(Pokemon.self, from: bulbasaurData)
            XCTAssertEqual(pokemonTypes.imageUrl, expectedImageURL)
            XCTAssertEqual(pokemonTypes.id, 1)
            XCTAssertEqual(pokemonTypes.name, "bulbasaur")
            XCTAssertEqual(pokemonTypes.primaryType, "grass")
            XCTAssertEqual(pokemonTypes.secondaryType, "poison")
        }
    }

}
