//
//  Calendar+Extensions.swift
//  CounterStrikeTVDomain
//
//  Created by Victor Marcel on 20/07/25.
//

import Foundation

public extension Calendar {
    
    // MARK: - METHODS
    
    func isDateInNextWeek(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let today = Date()
        
        guard let oneWeekLater = self.date(byAdding: .day, value: Numbers.seven, to: today) else {
            return false
        }
        
        return date >= today && date <= oneWeekLater
    }
}
