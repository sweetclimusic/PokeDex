//
//  ProgressView.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 21/01/2025.
//

import SwiftUI

extension PokeApi.Pokemon {
    
    struct LoadingView: View {
        var systemImageName: String =  "chevron.down.2"
        
        var description: String = "Loading..."
        
        internal let inspection = Inspection<Self>()
        
        var body: some View {
            NoContentView(
                systemImageName: systemImageName,
                description: description,
                buttonText: "",
                buttonAction: nil
            )
            .symbolEffect(.wiggle.down.byLayer, options: .repeat(.continuous))
            .onReceive(
                    inspection.notice
                ) {
                    self.inspection.visit(self,$0)
                }
        }
    }
}
