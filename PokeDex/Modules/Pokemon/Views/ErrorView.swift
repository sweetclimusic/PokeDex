//
//  ErrorView.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 21/01/2025.
//

import SwiftUI

extension PokeApi.Pokemon {
    
    struct ErrorView: View {
        var errorMessage: String?
        var systemImageName: String = "exclamationmark.triangleh"
        
        var description: String { "Oh No! we encountered an error \(String(describing: errorMessage))" }
        
        var buttonText: String = "Cancel"
        
        var buttonAction: VoidHandler?
        
        var body: some View {
            NoContentView(
                systemImageName: systemImageName,
                description: description,
                buttonText: buttonText,
                buttonAction: buttonAction
            )
        }
    }
}
