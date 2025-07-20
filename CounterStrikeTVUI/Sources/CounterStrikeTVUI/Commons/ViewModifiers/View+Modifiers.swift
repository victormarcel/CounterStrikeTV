//
//  View+Modifiers.swift
//  CounterStrikeTVUI
//
//  Created by Victor Marcel on 19/07/25.
//

import Foundation
import SwiftUI

extension View {
    
    // MARK: - METHODS
    
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
         if conditional {
             return AnyView(content(self))
         } else {
             return AnyView(self)
         }
     }
}
