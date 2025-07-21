//
//  FullContainerCenter.swift
//  CounterStrikeTVUI
//
//  Created by Victor Marcel on 20/07/25.
//

import Foundation
import SwiftUI

struct FullContainerCenter: ViewModifier {
    
    // MARK: - INTERNAL METHODS
    
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                content
                Spacer()
            }
            Spacer()
        }
    }
}

// MARK: - VIEW EXTENSION MODIFIER

extension View {
    
    func fullContainerCenter() -> some View {
        self.modifier(FullContainerCenter())
    }
}
