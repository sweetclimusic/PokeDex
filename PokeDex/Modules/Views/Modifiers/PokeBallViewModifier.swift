//
//  PokeBall.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 21/01/2025.
//

import SwiftUICore

/// Makes a gradient colors to the system Image to resemble the standard Pokeball
struct PokeBall: ViewModifier {
    var fontSize: Font = .title
    func body(content: Content) -> some View {
        content
            .font(fontSize)
            .symbolRenderingMode(.palette)
            .foregroundStyle(
                .linearGradient(colors: [.black,.white,.black], startPoint: .leading, endPoint: .trailing),
                .linearGradient(colors: [.red,.white,.blue], startPoint: .top, endPoint: .bottom)
            )
    }
}
