//
//  PokeApiPokemonSpies.swift
//  PokeDexTests
//
//  Created by Ashlee Muscroft on 28/01/2025.
//

import XCTest
@testable import PokeDex

typealias InteractorLogicSpy = PokeApiPokemonBusinessLogic & PokeApiPokemonDataStore
class PokeApiPokemonInteractorLogicSpy: InteractorLogicSpy {
    var selectedPokemon: PokeDex.Pokemon?
    
    var pokemonData: [PokeDex.Pokemon] = []
    
    var nextPage: Int?
    
    var previousPage: Int?
    
    var getViewContentsCount: Int = 0
    var didGetViewContents: Bool = false
    var didRefreshPokemonCount: Int = 0
    var didLoadMorePokemonCount: Int = 0
    var didRefreshPokemonData: Bool = false
    var didLoadMorePokemonData: Bool = false
    
    func getViewContents(offset: Int?, limit: Int?) async throws -> PokeDex.PokeApi.Pokemon.ViewContents.ViewModel {
        getViewContentsCount += 1
        didGetViewContents = true
        return stubbedViewModel
    }
    
    func loadmorePokemonData(offset: Int?, limit: Int?) async -> [PokeDex.Pokemon] {
        didLoadMorePokemonCount += 0
        didLoadMorePokemonData = true
        return stubbedViewModel.pokemon
    }
    
    func refreshPokemonData() async -> [PokeDex.Pokemon] {
        didRefreshPokemonCount += 1
        didRefreshPokemonData = true
        return stubbedViewModel.pokemon
    }
    
    
    var stubbedViewModel: PokeDex.PokeApi.Pokemon.ViewContents.ViewModel = .init(
        pokemon: [],
        currentPage: 20,
        nextPage: nil,
        previousPage: nil
    )
    
    func getViewContents() async throws -> PokeDex.PokeApi.Pokemon.ViewContents.ViewModel {
        getViewContentsCount += 1
        didGetViewContents = true
        return stubbedViewModel
    }

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
