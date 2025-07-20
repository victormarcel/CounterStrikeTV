//
//  Date+Extensions.swift
//  CounterStrikeTVDomain
//
//  Created by Victor Marcel on 16/07/25.
//

import Foundation

public extension Date {
    
    // MARK: - ENUM's
    
    enum Format: String {
        case utc = "yyyy-MM-dd'T'HH:mm:ss"
    }
    
    // MARK: - METHODS
    
    func add(days: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: days, to: self)
    }
    
    func add(years: Int) -> Date? {
        return Calendar.current.date(byAdding: .year, value: years, to: self)
    }
    
    func subtract(days: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: -days, to: self)
    }
    
    func dateStringBy(format: Format) -> String {
        let formatter = buildDateFormatterBy(format)
        return formatter.string(from: self)
    }
    
    // MARK: - PRIVATE METHODS
    
    private func buildDateFormatterBy(_ format: Format) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter
    }
}
