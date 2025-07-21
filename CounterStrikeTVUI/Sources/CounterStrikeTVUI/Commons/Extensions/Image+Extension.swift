//
//  Image+Extension.swift
//  CounterStrikeTVUI
//
//  Created by Victor Marcel on 20/07/25.
//

import Foundation
import SwiftUI

extension Image {
    
    static func icon(_ image: AppImage) -> Image {
        return Image(image.rawValue, bundle: .module)
    }
}
