//
//  PokeTypesService.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 20/01/2025.
//

import Foundation

/// Retrieves pokemon  from the PokeApi.co
final class PokemonService: PokeApiGetService {
    typealias APIType = Pokemon
    private let pokeApiEnpoint: Endpoints = .pokemon
    func get(page: Int? = 0) async throws -> [Pokemon] {
        do {
            let request = URLRequest(
                url: pokeApiEnpoint(),
                cachePolicy: cachePolicy
            )
            let (data, response) = try await urlSession.data(for: request)
            let decoder = JSONDecoder()
            let debug = String(data:data,encoding: .utf8)
            let pokemon = try decoder.decode(PokemonSpecies.self, from: data)
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    return pokemon.results
                case 400:
                    throw PokeAPIEndpointError.badRequestError
                case 404:
                    throw PokeAPIEndpointError.notFoundError
                default:
                    throw PokeAPIEndpointError.unknownError
                }
            }
            
            return pokemon.results
        } catch {
            throw PokeAPIEndpointError.unknownError
        }
    }
    
    func get(by id: Int) async throws -> Pokemon {
        do {
            let request = URLRequest(
                url: pokeApiEnpoint.getEndpoint(with: id) ,
                cachePolicy: cachePolicy
            )
            let (data,response) = try await urlSession.data(for: request)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let pokemonData = try decoder.decode(Pokemon.self, from: data)
            
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
        } catch let error as URLError {
            if error.code == .notConnectedToInternet {
                throw PokeAPIEndpointError.noInternetError
            }
            throw PokeAPIEndpointError.unknownError
        } catch {
            throw PokeAPIEndpointError.unknownError
        }
    }
    
    var urlSession: any URLSessionProtocol = URLSession.shared
    var cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad

}
