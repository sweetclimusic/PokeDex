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
    var selectedPokemon: PokeDex.PokeApi.Pokemon?
    
    var pokemonData: [PokeDex.PokeApi.Pokemon] = []
    
    var nextPage: Int?
    
    var previousPage: Int?
    
    var getViewContentsCount: Int = 0
    var didGetViewContents: Bool = false
    var didRefreshPokemonCount: Int = 0
    var didLoadMorePokemonCount: Int = 0
    var didRefreshPokemonData: Bool = false
    var didLoadMorePokemonData: Bool = false
    
    func getViewContents(offset: Int?, limit: Int?) async throws -> PokeDex.ViewContents.ViewModel {
        getViewContentsCount += 1
        didGetViewContents = true
        return stubbedViewModel
    }
    
    func loadmorePokemonData(offset: Int?, limit: Int?) async -> [PokeDex.PokeApi.Pokemon] {
        didLoadMorePokemonCount += 0
        didLoadMorePokemonData = true
        return stubbedViewModel.pokemon
    }
    
    func refreshPokemonData() async -> [PokeDex.PokeApi.Pokemon] {
        didRefreshPokemonCount += 1
        didRefreshPokemonData = true
        return stubbedViewModel.pokemon
    }
    
    
    var stubbedViewModel: PokeDex.ViewContents.ViewModel = .init(
        pokemon: [],
        currentPage: 20,
        nextPage: nil,
        previousPage: nil
    )
    
    func getViewContents() async throws -> PokeDex.ViewContents.ViewModel {
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
    var didDataFetchRequest: Bool = false
    var dataFetchRequestArgs: [URLRequest] = []
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        dataFetchRequestUrl = request.url?.absoluteString
        dataFetchRequestCount += 1
        dataFetchRequestArgs.append(request)
        didDataFetchRequest = true
        //return the stubbed properties above
        return (stubbedFetchedData, stubbedResponseNone)
    }
}



class PokeApiPokemonPresentorLogicSpy: PokeApiPokemonPresentationLogic {
    var didPresentErrorCalled: Bool = false
    var didPresentErrorCalledCount: Int = 0
    var presentErrorParameters: (
        PokeDex.ViewContents.Response,
        Void
    )!
    var presentErrorParametersList = [(
        PokeDex.ViewContents.Response,
        Void
    )]()
    var studdedPresentErrorViewModel: PokeDex.ViewContents.ViewModel!
    
    func presentError(response: PokeDex.ViewContents.Response, errorType: PokeAPIEndpointError) -> PokeDex.ViewContents.ViewModel {
        didPresentErrorCalled = true
        didPresentErrorCalledCount += 1
        presentErrorParameters = (response, ())
        presentErrorParametersList.append((response, ()))
        return studdedPresentErrorViewModel
    }

    var didPresentViewContentsCalledCount: Int = 0
    var didPresentViewContentsCalled: Bool = false
    var presentViewContentsParameters: (
        PokeDex.ViewContents.Response,
        Void
    )!
    var presentViewContentsParametersList = [(
        PokeDex.ViewContents.Response,
        Void
    )]()
    
    var studdedPresentViewContentsResponse: PokeDex.ViewContents.ViewModel!
    func presentViewContents(response: PokeDex.ViewContents.Response) -> PokeDex.ViewContents.ViewModel {
        didPresentViewContentsCalled = true
        didPresentViewContentsCalledCount += 1
        presentViewContentsParameters = (response, ())
        presentViewContentsParametersList.append((response, ()))
        return studdedPresentViewContentsResponse
    }
}
