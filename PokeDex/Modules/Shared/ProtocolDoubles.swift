//
//  ProtocolDoubles.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 20/01/2025.
//

import Foundation

/// reimplementation of URLSession for testing and to mock the results of a URLSession request during testing.
///
///  This must implement the required open functions dataTask from URLSession, it must be defined the same to behave as 1:1 URLSession
protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}


extension URLSession: URLSessionProtocol{}
