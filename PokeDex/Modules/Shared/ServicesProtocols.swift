//
//  ServicesProtocols.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 20/01/2025.
//
import Foundation

protocol PokeApiGetService {
    associatedtype APIType: Decodable & Hashable
    var urlSession: URLSessionProtocol { get }
    var cachePolicy: NSURLRequest.CachePolicy { get }
    
    /// Generic GET function to get the given Decodable type from Pokeapi, uses default paging
    ///
    /// **Parameter:** page: Int?
    ///
    /// **Return:** [T]
    ///
    func get(page: Int?, limit: Int?) async throws -> [APIType]
    
    /// Generic GET function to get the given Decodable T type from Pokeapi
    ///
    /// **Parameter:** id: Int
    ///
    /// **Return:** T
    func get(by id: Int) async throws -> APIType
}
