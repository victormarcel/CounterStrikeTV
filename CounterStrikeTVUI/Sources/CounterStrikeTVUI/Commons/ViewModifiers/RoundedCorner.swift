//
//  RoundedCorner.swift
//  CounterStrikeTVUI
//
//  Created by Victor Marcel on 17/07/25.
//

import Foundation
import SwiftUI

struct RoundedCorner: Shape {
    
    // MARK: - INTERNAL PROPERTIES
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    // MARK: - INTERNAL METHODS
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// MARK: - VIEW EXTENSION MODIFIER

extension View {
    
    func roundedCorners(
        _ radius: CGFloat,
        corners: UIRectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight]
    ) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
