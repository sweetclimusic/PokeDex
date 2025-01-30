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
struct PokeApiStandardResultNode: Decodable, Identifiable, Hashable {
    let id: UUID = UUID()
    let name: String
    let url: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(url)
    }
}

// I don't use the Habitat as that is a seperate https get request

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

// MARK: - PokemonStats
struct PokemonStats {
    let stats: [StatElement]
}

// MARK: - StatElement
struct StatElement {
    let baseStat, effort: Int
    let stat: StatStat
}

// MARK: - StatStat
struct StatStat {
    let name: String
    let url: String
}



struct PokemonTypes: Decodable, Hashable {
    let slot: Int
    let pokemonType: PokemonType

    enum CodingKeys: String, CodingKey {
        case slot
        case pokemonType = "type"
    }
}
/// Pokemon Data types retrieved from the pokeapi.co, marked as codable so as to store in userdefaults. the pokeapi.co is only for get requests, we will not be encoding or posting data to a service
struct PokemonType: Decodable, Identifiable, Equatable, Hashable {
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
            results =
                (try? container.decode([PokeApiStandardResultNode].self, forKey: .results)) ?? []
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

// MARK: - Sprites
struct Sprites: Decodable {
    var frontShiny: String?
    var frontDefault: String?
    var other: Other?

    enum CodingKeys: String, CodingKey {
        case frontShiny = "front_shiny"
        case frontDefault = "front_default"
        case other
    }
}

struct Other: Decodable {
    var officialArtwork: OfficialArtwork?

    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct OfficialArtwork: Decodable {
    var frontDefault: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
// MARK: - Pokemon
/// Converted PokeApi response to represent a Pokemon in our Pokedex
struct Pokemon: Decodable, Identifiable, Hashable {
    var id: Int?
    var name: String?
    var imageUrl: String? {
        //get Decode nested sprite data
        get {
            let url = self.sprites?.other?.officialArtwork?.frontDefault ?? self.sprites?.frontDefault
            return url
        }
    }
    var primaryType: String? {
        type.first?.pokemonType.name
    }
    var secondaryType: String? {
        if type.last?.slot == 2 {
            return type.last?.pokemonType.name
        } else {
            return nil
        }
    }

    var type: [PokemonTypes] = []
    var pokemon: PokeApiStandardResultNode?
    var pokemonHabitat: PokemonHabitat?
    var sprites: Sprites?
    var stats: [PokemonStats] = []

    enum CodingKeys: String, CodingKey {
        case id, name, sprites
        case type = "types"
        case pokemon = "species"
    }

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }

    func hash (into hasher: inout Hasher) {
        hasher.combine(id!)
        hasher.combine(name!)
    }
    
    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name
    }
}
