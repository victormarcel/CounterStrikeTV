//
//  File.swift
//  CounterStrikeTVUI
//
//  Created by Victor Marcel on 16/07/25.
//

import Foundation
import UIKit

public extension UIColor {
    
    // MARK: - METHODS
    
    static func appColor(_ color: AppColor) -> UIColor {
        return UIColor(named: color.rawValue) ?? .clear
    }
}
