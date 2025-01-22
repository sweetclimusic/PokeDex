//
//  Displayable.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 22/01/2025.
//

import SwiftUI

protocol Displayable {
    func display() -> any View
    var viewType: any View.Type { get }
}
