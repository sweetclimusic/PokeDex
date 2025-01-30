//
//  SuperEffective.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 29/01/2025.
//
import SwiftUI

struct TextEffectModifier: ViewModifier {
    var color: Color = .white
       
    private let shadowStyleTop: ShadowStyle = .drop(color: .gray, radius: 3.0, x: 3, y: 3)
    private let shadowStyleBottom: ShadowStyle = .drop(color: .gray, radius: 8.0, x: 0, y: 0)
    @ViewBuilder
    func trackinTextEffect(_ content: Self.Content) -> some View {
        content
            .padding(EdgeInsets(top: 4,leading: 4,bottom: 0,trailing: 0))
            .font(.caption)
            .foregroundStyle(
                .shadow(shadowStyleTop)
                .shadow(shadowStyleBottom)
            )
            .italic()
            .tracking(2)
            .foregroundStyle(color)
    }
    
    func body(content: Self.Content) -> some View {
        trackinTextEffect(content)
    }
}
