//
//  PokeDexApp.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 19/01/2025.
//

import SwiftUI

@main
struct PokeDexApp: App {
    var displayRouter = PokeApi.Pokemon.Router()
    var body: some Scene {
        WindowGroup {
            displayRouter.display() as? PokeApi.Pokemon.SceneView
        }
    }
}
