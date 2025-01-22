//
//  CardViewModifier.swift
//  PokeDex
//
//  Created by Ashlee Muscroft on 19/01/2025.
//

import SwiftUICore

struct CardBackground: ViewModifier {
    var themeColor: Color = .blue
    var color: Color = .orange
    var shadowColor: Color = .gray
    let shadowStyleTop: ShadowStyle = .drop(color: .gray, radius: 3.0, x: 3, y: 3)
    let shadowStyleBottom: ShadowStyle = .drop(color: .gray, radius: 8.0, x: 0, y: 0)
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    ZStack {
                        themeColor
                            .clipShape(Rectangle())
                        
                        LinearGradient(
                            colors: [Color(.systemBackground), color],
                            startPoint: .init(x: 0.85, y: 0),
                            endPoint: .init(x: 0.95, y: 1)
                        )
                        .clipShape(CornerTriangle())
                        
                        ContentSeperator()
                    }
                }
            )
    }
}

fileprivate struct CornerTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.closeSubpath()
        return path
    }
}

fileprivate struct ContentSeperator: Shape {
    var color: Color = .orange
    var lineWidth: CGFloat = 1.0
    let shadowStyleTop: ShadowStyle = .drop(color: .gray, radius: 3.0, x: 3, y: 3)
    let shadowStyleBottom: ShadowStyle = .drop(color: .gray, radius: 8.0, x: 0, y: 0)
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        return path
    }
    
    func detailStroke() -> some View {
        self.stroke(
            .gray,
            lineWidth: lineWidth
        ).foregroundStyle(
            .shadow(shadowStyleTop)
            .shadow(shadowStyleBottom)
        )
    }
}
