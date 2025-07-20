//
//  Color+Extensions.swift
//  CounterStrikeTVUI
//
//  Created by Victor Marcel on 16/07/25.
//

import Foundation
import SwiftUI

extension Color {
    
    // MARK: - METHODS
    
    static func appColor(_ color: AppColor) -> Color {
        return Color(color.rawValue, bundle: .module)
    }
}
