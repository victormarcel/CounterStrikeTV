//
//  View+Extensions.swift
//  CounterStrikeTVUI
//
//  Created by Victor Marcel on 18/07/25.
//

import Foundation
import SwiftUI
import UIKit

public extension View {
    
    var wrappedByHostingController: UIHostingController<Self> {
        return .init(rootView: self)
    }
}
