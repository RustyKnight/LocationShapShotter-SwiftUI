//
//  StokeModifier.swift
//  LocationSnapshot-SwiftUI
//
//  Created by Shane Whitehead on 19/1/2024.
//

import Foundation
import SwiftUI

public extension View {
    func stroke(color: Color, width: CGFloat = 1) -> some View {
        modifier(StrokeModifier(strokeSize: width, strokeColor: color))
    }
}

struct StrokeModifier: ViewModifier {
    private let id = UUID()
    var strokeSize: CGFloat = 1
    var strokeColor: Color = .blue
    
    func body(content: Content) -> some View {
        if strokeSize > 0 {
            appliedStrokeBackground(content: content)
        } else {
            content
        }
    }
    
    private func appliedStrokeBackground(content: Content) -> some View {
        content
            .padding(strokeSize * 2)
            .background(
                Rectangle()
                    .foregroundColor(strokeColor)
                    .mask(alignment: .center) {
                        mask(content: content)
                    }
            )
    }
    
    func mask(content: Content) -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.01))
            context.drawLayer { ctx in
                if let resolvedView = context.resolveSymbol(id: id) {
                    ctx.draw(
                        resolvedView,
                        at: CGPoint(
                            x: size.width / 2,
                            y: size.height / 2
                        )
                    )
                }
            }
        } symbols: {
            content
                .tag(id)
                .blur(radius: strokeSize)
        }
    }
}
