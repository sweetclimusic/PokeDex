//
//  HandlerProtocols.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 21/01/2025.
//

import Foundation

public typealias Handler<T> = (() -> T)
public typealias VoidHandler = Handler<Void>
