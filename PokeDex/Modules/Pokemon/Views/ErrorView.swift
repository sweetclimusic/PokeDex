//
//  ErrorView.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 21/01/2025.
//

import SwiftUI

extension PokeDex {
    
    struct ErrorView: View {
        var errorMessage: String?
        var systemImageName: String = "exclamationmark.triangle"
        
        var description: String { "Oh No! we encountered an error \(String(describing: errorMessage))" }
        
        var buttonText: String = "Cancel"
        
        var buttonAction: VoidHandler?
        
        internal let inspection = Inspection<Self>()
        
        var body: some View {
            NoContentView(
                systemImageName: systemImageName,
                description: description,
                buttonText: buttonText,
                buttonAction: buttonAction
            ).onReceive(
                inspection.notice
            ) {
                self.inspection.visit(self,$0)
            }
        }
    }
}
