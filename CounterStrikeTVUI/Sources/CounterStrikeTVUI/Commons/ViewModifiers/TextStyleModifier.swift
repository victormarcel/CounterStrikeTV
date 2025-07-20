//
//  TextStyleModifier.swift
//  CounterStrikeTVUI
//
//  Created by Victor Marcel on 17/07/25.
//

import Foundation
import SwiftUI

struct TextStyleModifier: ViewModifier {
    
    // MARK: - INTERNAL PROPERTIES
    
    var fontSize: CGFloat
    var color: Color
    
    // MARK: - INTERNAL METHODS
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: fontSize))
            .foregroundColor(color)
    }
}

// MARK: - VIEW EXTENSION MODIFIER

extension View {
    
    func textStyle(fontSize: CGFloat, color: Color) -> some View {
        self.modifier(TextStyleModifier(fontSize: fontSize, color: color))
    }
}
