//
//  File.swift
//  CounterStrikeTVUI
//
//  Created by Victor Marcel on 20/07/25.
//

import Foundation
import SwiftUI

extension PlayerItemListView {
    
    enum ImagePosition {
        
        // MARK: - CASES
        
        case leading
        case trailing
        
        // MARK: - PROPERTIES
        
        var edge: Edge.Set {
            switch self {
            case .leading:
                return .leading
            case .trailing:
                return .trailing
            }
        }
        
        var oppositeEdge: Edge.Set {
            switch self {
            case .leading:
                return .trailing
            case .trailing:
                return .leading
            }
        }
    }

}
