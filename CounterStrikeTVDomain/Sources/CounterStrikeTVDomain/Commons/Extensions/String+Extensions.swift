//
//  String+Extensions.swift
//  CounterStrikeTVDomain
//
//  Created by Victor Marcel on 16/07/25.
//

import Foundation

public extension String {
    
    // MARK: - PUBLIC PROPERTIES
    
    static var empty: String {
        return ""
    }
    
    // MARK: - PUBLIC METHODS
    
    func localizedBy(bundle: Bundle) -> String {
        String(localized: .init(self), bundle: bundle)
    }
    
    func dateBy(format: Date.Format) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = format.rawValue
        
        return formatter.date(from: self)
    }
}
