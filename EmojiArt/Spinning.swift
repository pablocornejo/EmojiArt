//
//  Spinning.swift
//  EmojiArt
//
//  Created by Pablo Cornejo on 7/19/20.
//  Copyright © 2020 Pablo Cornejo Pierola. All rights reserved.
//

import SwiftUI

struct Spinning: ViewModifier {
    @State private var angle: Angle = .degrees(0)
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(angle)
            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) // Implicit animation
            .onAppear { self.angle = .degrees(360) }
    }
    
    // Another way:
//    @State private var isVisible: Bool = false
//
//    func body(content: Content) -> some View {
//        content
//            .rotationEffect(Angle.degrees(isVisible ? 360: 0))
//            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) // Implicit animation
//            .onAppear { self.isVisible = true }
//    }
}

extension View {
    func spinning() -> some View {
        modifier(Spinning())
    }
}
