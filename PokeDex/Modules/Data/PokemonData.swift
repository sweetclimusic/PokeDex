//
//  PokemonData.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 20/01/2025.
//
import Foundation
import SwiftUI

// MARK: - PokeApiNode
/// Basic result type returned from the PokeAPI, the result being a `name:String` and `url:String`
struct PokeApiStandardResultNode: Codable {
    let name: String
    let url: String
}

//   let pokemonHabit = try? JSONDecoder().decode(PokemonHabit.self, from: jsonData)

// MARK: - PokemonHabitat
struct PokemonHabitat: Codable, Sendable {
    let id: Int
    let name: String
    let location: Location
}

// MARK: - Location
struct Location: Codable, Sendable {
    let name: String
    let url: String
}

struct PokemonTypes: Decodable, Hashable {
    let count: Int
    let results: [PokemonType]

    enum CodingKeys: String, CodingKey {
        case count, results
    }

    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            count = try container.decode(Int.self, forKey: .count)
            results = (try? container.decode([PokemonType].self, forKey: .results)) ?? []
        }
    }
}
/// Pokemon Data types retrieved from the pokeapi.co, marked as codable so as to store in userdefaults. the pokeapi.co is only for get requests, we will not be encoding or posting data to a service
struct PokemonType: Codable, Identifiable, Equatable, Hashable {
    let id: UUID = UUID()
    let name: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case name, url
    }

    init(name typeName: String) {
        self.name = typeName
        self.url = "/"
    }

    init(from decoder: any Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)
            url = try container.decode(String.self, forKey: .url)
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(url)
    }

}

struct PokemonSpecies: Decodable {
    let count: Int
    let results: [PokeApiStandardResultNode]
    let next: String?
    let previous: String?

    enum CodingKeys: String, CodingKey {
        case count, results, next, previous
    }

    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            count = try container.decode(Int.self, forKey: .count)
            results = (try? container.decode([PokeApiStandardResultNode].self, forKey: .results)) ?? []
            next = try? container.decodeIfPresent(String.self, forKey: .next)
            previous = try? container.decodeIfPresent(String.self, forKey: .previous)
            return
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let error as NSError {
            print("Error decoding Pokemon:", error.localizedDescription)
        } catch {
            print("Error decoding Pokemon:", error.localizedDescription)
        }
        throw PokeAPIEndpointError.unknownError
    }
}

// MARK: - Pokemon
/// Converted PokeApi response to represent a Pokemon in our Pokedex
struct Pokemon: Decodable {
    var id: Int?
    var name: String?
    var imageUrl: String? = nil
    var primaryType: String? {
        type.first
    }
    var secondaryType: String? {
        type.last
    }
    var type: [String] = []
    var pokemon: PokeApiStandardResultNode?
    var pokemonHabitat: PokemonHabitat?

    enum CodingKeys: String, CodingKey {
        case id, name, type, pokemon
        case sprites
    }

    enum SpritesKeys: String, CodingKey {
        case frontDefault = "front_default"
        case other
    }

    enum OtherKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }

    enum ArtworkKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    init(from decoder: any Decoder) throws {
        do {

            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
            name = try container.decodeIfPresent(String.self, forKey: .name)
            type = try container.decodeIfPresent([String].self, forKey: .type) ?? []
            pokemon = try container.decodeIfPresent(
                PokeApiStandardResultNode.self, forKey: .pokemon)

            // Decode nested sprite data
            if let spritesContainer = try? container.nestedContainer(
                keyedBy: SpritesKeys.self, forKey: .sprites),
                let otherContainer = try? spritesContainer.nestedContainer(
                    keyedBy: OtherKeys.self, forKey: .other),
                let artworkContainer = try? otherContainer.nestedContainer(
                    keyedBy: ArtworkKeys.self, forKey: .officialArtwork) {
                // Try to get official artwork first, fall back to regular sprite
                if let artworkUrl = try? artworkContainer.decodeIfPresent(
                    String.self, forKey: .frontDefault)
                {
                    imageUrl = artworkUrl
                } else {
                    imageUrl = try? spritesContainer.decodeIfPresent(String.self, forKey: .frontDefault)
                }
            }

            
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let error as NSError {
            print("Error decoding Pokemon:", error.localizedDescription)
        } catch {
            print("Error decoding Pokemon:", error.localizedDescription)
        }
    }
}
