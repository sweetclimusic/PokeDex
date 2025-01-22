//
//  Endpoints.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 21/01/2025.
//

import Foundation

enum PokeAPIEndpointError: Error {
    case notFoundError
    case noInternetError
    case badRequestError
    case unknownError
}

enum PokemonImage: String {
    case sprite = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"
    case officialArtwork =
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/"

    func getImageUrl(id: Int) -> URL {
        return URL(string: self.rawValue.appending("\(id).png"))!
    }
}

enum Endpoints: String, Sendable {
    static let host: String = "https://pokeapi.co/api/v2/"
    static let imageHost: String =
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"
    case pokemon = "pokemon/"
    case locationArea = "location-area/"

    enum Image: String, Sendable {
        case sprite
        case officialArtwork = "other/official-artwork/"
        func getImageUrl(id: Int) -> URL {
            if self != .officialArtwork {
                return URL(string: Endpoints.imageHost.appending("\(id).png"))!
            }
            let officialArtwork = Endpoints.Image.officialArtwork.rawValue.appending("\(id).png")
            return URL(
                string: Endpoints.imageHost.appending(officialArtwork)
            )!
        }
    }

    func callAsFunction() -> URL {
        return URL(string: Endpoints.host.appending(rawValue))!
    }

    func getEndpoint(with id: Int) -> URL {
        return URL(string: Endpoints.host.appending(rawValue).appending("\(id)"))!
    }

}
