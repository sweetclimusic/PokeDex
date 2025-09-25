//
//  TestData.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 28/01/2025.
//
import Foundation
import ViewInspector
import SwiftUI

@testable import PokeDex
// enable a loopback for ViewInspector to capture async and response to views that have delay rendering
extension Inspection: @unchecked @retroactive Sendable {}
extension Inspection: @retroactive InspectionEmissary { }

// MARK: Testing namespace

struct Test{
    var httpResponseStatusCode = 200
}

extension Test {
    static let Interval: TimeInterval = 0.5
    static let Timeout: TimeInterval = 5.0
    
    static func getCharmanderJSON() -> Data {
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
    }
    """
        return response.data(using: .utf8)!
    }
    
    static func getSquirtleJSON() -> Data {
        let response = """
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
    }
    """
        return response.data(using: .utf8)!
    }
    
    static func getPikachuJSON() -> Data {
        let response = """
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
    }
    """
        return response.data(using: .utf8)!
    }
    
    static func getEeveeJSON() -> Data {
        let response = """
    {
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
    }
    """
        return response.data(using: .utf8)!
    }
    
    static func getBulbasaurJSON() -> Data  {
        let response = """
    {
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
}
