//
//  PokeApiPokemonSpies.swift
//  PokeDexTests
//
//  Created by Ashlee Muscroft on 28/01/2025.
//

import XCTest
@testable import PokeDex

class PokeApiPokemonBusinessLogicSpy: PokeApiPokemonBusinessLogic {
    var getViewContentsCount: Int = 0
    var didGetViewContents: Bool = false
    
    var stubbedViewModel: PokeDex.PokeApi.Pokemon.ViewContents.ViewModel = .init(pokemon: [])
    
    func getViewContents() async throws -> PokeDex.PokeApi.Pokemon.ViewContents.ViewModel {
        getViewContentsCount += 1
        didGetViewContents = true
        return stubbedViewModel
    }
}

typealias InteractorLogicSpy = PokeApiPokemonBusinessLogic & PokeApiPokemonDataStore
class PokeApiPokemonInteractorLogicSpy: InteractorLogicSpy {
    
    var stubbedViewModel: PokeDex.PokeApi.Pokemon.ViewContents.ViewModel = .init(pokemon: [])
    
    var getViewContentsCount: Int = 0
    var didGetViewContents: Bool = false
    
    func getViewContents() async throws -> PokeDex.PokeApi.Pokemon.ViewContents.ViewModel {
        getViewContentsCount += 1
        didGetViewContents = true
        return stubbedViewModel
    }
    
    var selectedPokemon: String?
    
    var nextPage: Int?
    
    var previousPage: Int?
    
    var pokemonSpeciesQueried: [PokeDex.PokeApiStandardResultNode] = []

}

class PokeApiGetRequestSpy: URLSessionProtocol {
    // optional, not used currently but set the stub
    var stubbedFetchedData: Data = Data()
    var stubbedResponseNone: URLResponse = URLResponse()
    
    var dataFetchRequestUrl: String? = nil
    var dataFetchRequestCount: Int = 0
    var didDataFetchRequestCount: Bool = false
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        dataFetchRequestUrl = request.url?.absoluteString
        dataFetchRequestCount += 1
        didDataFetchRequestCount = true
        //return the stubbed properties above
        return (stubbedFetchedData, stubbedResponseNone)
    }
}
