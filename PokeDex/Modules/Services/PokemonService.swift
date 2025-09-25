//
//  PokeTypesService.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 20/01/2025.
//

import Foundation
import os.log

/// Retrieves pokemon  from the PokeApi.co
final class PokemonService: PokeApiGetService {
    typealias APIType = PokeDex.PokeApi.Pokemon
    private let pokeApiEnpoint: Endpoints = .pokemon
    private let defaultLimit = 20
    
    func get(page: Int? = 0, limit: Int?) async throws -> [PokeDex.PokeApi.Pokemon] {
        do {
            var request = URLRequest(
                url: pokeApiEnpoint(),
                cachePolicy: cachePolicy
            )
            
            if let page {
                /// example page endpoint being
                /// "https://pokeapi.co/api/v2/pokemon/?offset=20&limit=20"
                request.url = request.url?.appending(queryItems: [
                    URLQueryItem(name: "offset", value: String(page)),
                    URLQueryItem(name: "limit", value: String(limit ?? defaultLimit)),
                ])
            }
            
            let (data, response) = try await urlSession.data(for: request)
            let decoder = JSONDecoder()
            let pokemonSpecies = try decoder.decode(PokeDex.PokeApi.PokemonSpecies.self, from: data)
            var pokemon = [PokeDex.PokeApi.Pokemon]()
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                    case 200:
                        pokemonSpecies.results.forEach { result in
                            if let id = result.url.idFromUrl(Endpoints.pokemon().absoluteString) {
                                let newPoke = PokeDex.PokeApi.Pokemon(
                                    id: id,
                                    name: result.name
                                )
                                
                                pokemon.append(newPoke)
                            }
                        }
                        return pokemon
                    case 400:
                        throw PokeAPIEndpointError.badRequestError
                    case 404:
                        throw PokeAPIEndpointError.notFoundError
                    default:
                        throw PokeAPIEndpointError.unknownError
                }
            }
            
            return pokemon
        } catch is URLError {
            throw PokeAPIEndpointError.noInternetError
        } catch {
            throw PokeAPIEndpointError.unknownError
        }
    }
    
    func get(by id: Int) async throws -> PokeDex.PokeApi.Pokemon {
        do {
            let request = URLRequest(
                url: pokeApiEnpoint.getEndpoint(with: id),
                cachePolicy: cachePolicy
            )
            let (data, response) = try await urlSession.data(for: request)
            let decoder = JSONDecoder()
            let pokemonData = try decoder.decode(PokeDex.PokeApi.Pokemon.self, from: data)
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                    case 200:
                        return pokemonData
                    case 400:
                        throw PokeAPIEndpointError.badRequestError
                    case 404:
                        throw PokeAPIEndpointError.notFoundError
                    default:
                        throw PokeAPIEndpointError.unknownError
                }
            }
            throw PokeAPIEndpointError.unknownError
        } catch is URLError {
            throw PokeAPIEndpointError.noInternetError
        } catch {
            throw PokeAPIEndpointError.unknownError
        }
    }
    
    var urlSession: any URLSessionProtocol = URLSession.shared
    var cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad
}

#if DEBUG
class MockURLSession: URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        return (getPokemonSpeciesJSON(), response)
    }
}

final class MockPokemonApiService: PokeApiGetService {
    typealias APIType = PokeDex.PokeApi.Pokemon
    var stubbPokemon: PokeDex.PokeApi.Pokemon = .init(id: 1, name: "Bulbasaur")
    var stubbedPokemon: [PokeDex.PokeApi.Pokemon] = []
    var stubbURLSession: URLSessionProtocol = MockURLSession()
    
    var getRequestArgs: [Int:(Int,Int)] = [:]
    var didGetRequestCount: Int = 0
    func get(page: Int? = nil, limit: Int?) async throws -> [PokeDex.PokeApi.Pokemon] {
        if let page, let limit {
            getRequestArgs[page] = (page,limit)
        }
        didGetRequestCount += 1
        let request = URLRequest(
            url: Endpoints.pokemon(),
            cachePolicy: cachePolicy
        )
        let (data, response) = try await urlSession.data(for: request)
        let decoder = JSONDecoder()
        let pokemonSpecies = try decoder.decode(
            PokeDex.PokeApi.PokemonSpecies.self,
            from: data
        )
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            pokemonSpecies.results.forEach { result in
                if let id = result.url.idFromUrl(Endpoints.pokemon().absoluteString) {
                    // create a new PokeDex.PokeApi.Pokemon entriy
                    let newPoke = PokeDex.PokeApi.Pokemon(
                        id: id,
                        name: result.name
                    )
                    stubbedPokemon.append(newPoke)
                }
            }
        }
        return stubbedPokemon
    }
    
    var getByIdRequestArgs = [Int]()
    var didGetByIdRequestCount: Int = 0
    @MainActor
    func get(by id: Int) async throws -> PokeDex.PokeApi.Pokemon {
        getByIdRequestArgs.append(id)
        didGetByIdRequestCount += 1
        if id != stubbPokemon.id {
            return PokeDex.PokeApi.Pokemon(id: id, name: "Not the stubbed Pokemon")
        }
        
        return stubbPokemon
    }
    
    
    
    var urlSession: any URLSessionProtocol {
        stubbURLSession
    }
    
    var cachePolicy: NSURLRequest.CachePolicy {
        .returnCacheDataDontLoad
    }
}
//Mock pokemon json
fileprivate func getPokemonSpeciesJSON() -> Data {
    let response = """
    {
        "count": 5,
        "next": null,
        "previous": null,
        "results": [
            {
                "name":"charmander",
                "url":"https://pokeapi.co/api/v2/pokemon/4/"
            },
            {
                "name":"squirtle",
                "url":"https://pokeapi.co/api/v2/pokemon/7/"
            },
            {
                "name":"pikachu",
                "url":"https://pokeapi.co/api/v2/pokemon/25/"
            },
            {
                "name":"eevee",
                "url":"https://pokeapi.co/api/v2/pokemon/133/"
            },
            {
                "name":"bulbasaur",
                "url":"https://pokeapi.co/api/v2/pokemon/1/"
            }
        ]
    }
    """
    return response.data(using: .utf8)!
}

fileprivate func getPokemonJSON() -> Data {
    let response = """
     {
        "id":4,
        "is_default":true,
        "name":"charmander",
        "order":4,
        "past_abilities":[],
        "past_types":[],
        "species":{"name":"charmander","url":"https://pokeapi.co/api/v2/pokemon-species/4/"},
        "sprites":{
            "front_default":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png",
            "front_shiny":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/4.png",
            "other":{
                "official-artwork":{
                    "front_default":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/4.png"
                }
            }
        },
        "types":[
            {"slot":1,"type":{"name":"fire","url":"https://pokeapi.co/api/v2/type/10/"}}
        ],
        "weight":85
     },
     {
        "id":7,
        "is_default":true,
        "name":"squirtle",
        "order":7,
        "past_abilities":[],
        "past_types":[],
        "species":{"name":"squirtle","url":"https://pokeapi.co/api/v2/pokemon-species/7/"},
        "sprites":{
            "front_default":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png",
            "front_shiny":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/7.png",
            "other":{
                "official-artwork":{
                    "front_default":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/7.png"
                }
            }
        },
        "types":[
            {"slot":1,"type":{"name":"water","url":"https://pokeapi.co/api/v2/type/11/"}}
        ],
        "weight":90
     },
     {
        "id":25,
        "is_default":true,
        "name":"pikachu",
        "order":25,
        "past_abilities":[],
        "past_types":[],
        "species":{"name":"pikachu","url":"https://pokeapi.co/api/v2/pokemon-species/25/"},
        "sprites":{
            "front_default":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png",
            "front_shiny":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/25.png",
            "other":{
                "official-artwork":{
                    "front_default":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png"
                }
            }
        },
        "types":[
            {"slot":1,"type":{"name":"electric","url":"https://pokeapi.co/api/v2/type/13/"}}
        ],
        "weight":60
     },{
        "id":133,
        "is_default":true,
        "name":"eevee",
        "order":133,
        "past_abilities":[],
        "past_types":[],
        "species":{"name":"eevee","url":"https://pokeapi.co/api/v2/pokemon-species/133/"},
        "sprites":{
            "front_default":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/133.png",
            "front_shiny":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/133.png",
            "other":{
                "official-artwork":{
                    "front_default":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/133.png"
                }
            }
        },
        "types":[
            {"slot":1,"type":{"name":"normal","url":"https://pokeapi.co/api/v2/type/1/"}}
        ],
        "weight":65
     },{
        "id":1,
        "is_default":true,
        "name":"bulbasaur",
        "order":1,
        "past_abilities":[],
        "past_types":[],
        "species":{"name":"bulbasaur","url":"https://pokeapi.co/api/v2/pokemon-species/1/"},
        "sprites":{
            "front_default":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
            "front_shiny":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png",
            "other":{
                "official-artwork":{
                    "front_default":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"
                }
            }
        },
        "types":[
            {"slot":1,"type":{"name":"grass","url":"https://pokeapi.co/api/v2/type/12/"}},
            {"slot":2,"type":{"name":"poison","url":"https://pokeapi.co/api/v2/type/4/"}}
        ],
        "weight":69
     }
     """
    return response.data(using: .utf8)!
}
#endif
