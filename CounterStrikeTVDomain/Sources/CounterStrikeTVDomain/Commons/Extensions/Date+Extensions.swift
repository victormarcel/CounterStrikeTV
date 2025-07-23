//
//  Date+Extensions.swift
//  CounterStrikeTVDomain
//
//  Created by Victor Marcel on 16/07/25.
//

import Foundation

public extension Date {
    
    // MARK: - CONSTANTS
    
    private enum Constants {
        static let today = "today".localizedBy(bundle: .module).capitalized
        static let tomorrow = "tomorrow".localizedBy(bundle: .module).capitalized
        static let hourAndMinutesFormat = "hour_minutes_format".localizedBy(bundle: .module)
        static let abbreviationHourAndMinutesFormat = "abbrev_hour_minutes_format".localizedBy(bundle: .module)
    }
    
    // MARK: - ENUM's
    
    enum Format: String {
        case utc = "yyyy-MM-dd'T'HH:mm:ssZ"
        case dayAbbreviationAndHourAndMinutesSplitByComma = "E, HH:mm"
        case dateTimeSplitByComma = "dd/MM, HH:mm"
    }
    
    // MARK: - PROPERTIES
    
    var dateAbbreviationDescription: String {
        let calendar = Calendar.current
        var text: String
        let hourAndMinutesFormatter = buildDateFormatterBy(Constants.hourAndMinutesFormat)
        
        if calendar.isDateInToday(self) {
            text = "\(Constants.today), \(hourAndMinutesFormatter.string(from: self))"
        } else if calendar.isDateInTomorrow(self) {
            text = "\(Constants.tomorrow), \(hourAndMinutesFormatter.string(from: self))"
        } else if calendar.isDateInNextWeek(self) {
            text = buildDateFormatterBy(
                Constants.abbreviationHourAndMinutesFormat
            ).string(from: self)
        } else {
            text = buildDateFormatterBy(.dateTimeSplitByComma).string(from: self)
        }
        
        return text
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
        return buildDateFormatterBy(format.rawValue)
    }
    
    private func buildDateFormatterBy(_ string: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = string
        return dateFormatter
    }
}
