//
//  Shimmer.swift
//  Assignment
//
//  Created by thanh tien on 24/4/25.
//

import SwiftUI

struct Shimmer: ViewModifier {
    @State var isInitialState: Bool = true

    func body(content: Content) -> some View {
        content
            .mask {
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            Color.black.opacity(0.4),
                            Color.black.opacity(0.1),
                            Color.black.opacity(0.4)
                        ]
                    ),
                    startPoint: (isInitialState ? .init(x: -0.5, y: -0.5) : .init(x: 1, y: 1)),
                    endPoint: (isInitialState ? .init(x: 0, y: 0) : .init(x: 1.5, y: 1.5))
                )
            }
            .animation(.linear(duration: 1.5).delay(0.25).repeatForever(autoreverses: false), value: isInitialState)
            .onAppear {
                isInitialState = false
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(Shimmer())
    }
}
