//
//  CircleButtonStyle.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 22/01/2025.
//

import SwiftUI

struct CircleButtonStyle: ButtonStyle {
    var color: Color
        func makeBody(configuration: Configuration) -> some View {
            CircleButton(circleConfiguration: configuration, buttonColor: color, pressAnimation: 0.33)
    }
    
    struct CircleButton: View {
        let circleConfiguration: Configuration
        var buttonColor: Color
        var pressAnimation: Double
        @State var opacity: Double = 1.0
        var body: some View {
            // Default destructive colors to red, (iOS standard design pattern)
            let backGroundColor : Color = (circleConfiguration.role == .destructive ? .red : buttonColor)
            return circleConfiguration.label
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(25)
                .background(
                    Circle()
                        .fill(backGroundColor)
                )
                .compositingGroup()
                .shadow(color:.black,radius: 3)
                .opacity(circleConfiguration.isPressed ? pressAnimation : 1.0)
            }
        }
}
