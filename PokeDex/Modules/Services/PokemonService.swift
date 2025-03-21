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
    typealias APIType = Pokemon
    private let pokeApiEnpoint: Endpoints = .pokemon
    private let defaultLimit = 20

    func get(page: Int? = 0, limit: Int?) async throws -> [Pokemon] {
        do {
            var request = URLRequest(
                url: pokeApiEnpoint(),
                cachePolicy: cachePolicy
            )

            if let page {
                // "https://pokeapi.co/api/v2/pokemon/?offset=20&limit=20"
                request.url = request.url?.appending(queryItems: [
                    URLQueryItem(name: "offset", value: String(page)),
                    URLQueryItem(name: "limit", value: String(limit ?? defaultLimit)),
                ])
            }

            let (data, response) = try await urlSession.data(for: request)
            let decoder = JSONDecoder()
            let pokemonSpecies = try decoder.decode(PokemonSpecies.self, from: data)
            var pokemon = [Pokemon]()

            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    pokemonSpecies.results.forEach { result in
                        if let id = result.url.idFromUrl(Endpoints.pokemon().absoluteString) {
                            // create a new Pokemon entriy
                            let newPoke = Pokemon(
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

    func get(by id: Int) async throws -> Pokemon {
        do {
            let request = URLRequest(
                url: pokeApiEnpoint.getEndpoint(with: id),
                cachePolicy: cachePolicy
            )
            let (data, response) = try await urlSession.data(for: request)
            let decoder = JSONDecoder()
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
        } catch is URLError {
            throw PokeAPIEndpointError.noInternetError
        } catch {
            throw PokeAPIEndpointError.unknownError
        }
    }

    var urlSession: any URLSessionProtocol = URLSession.shared
    var cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad
}
