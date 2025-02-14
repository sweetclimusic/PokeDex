//
//  NoInternetView.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 21/01/2025.
//
import SwiftUI

extension PokeApi.Pokemon {
    
    struct NoInternetView: View, StateViewModel {
        
        var systemImageName: String = "network.slash"
        
        var description: String = "No Internet connect, please try again"
        
        var buttonText: String = "Retry"
        
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
