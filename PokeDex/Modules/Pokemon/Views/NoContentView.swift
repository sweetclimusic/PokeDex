//
//  NoContentView.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 21/01/2025.
//

import SwiftUI

extension PokeApi.Pokemon {
    protocol StateViewModel {
        var systemImageName: String { get }
        var description: String { get }
        var buttonText: String { get }
        var buttonAction: VoidHandler? { get }
    }
    
    struct NoContentView: View, StateViewModel {
        var systemImageName: String =  "bolt.horizontal.circle"
        var description: String = "No Pokemon found, please try again"
        var buttonText: String = "Retry"
        var buttonAction: VoidHandler?

        var body: some View {
            ContentUnavailableView(
                label: {
                    Label("", systemImage: systemImageName)
                        .modifier(PokeBall())
                },
                description: {
                    Text(
                        description
                    ).font(.headline)
                },
                actions: {
                    Button(buttonText) {
                        buttonAction?()
                    }
                })
        }
    }
}

#Preview {
    PokeApi.Pokemon.NoContentView()
}
