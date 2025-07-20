//
//  MatchStatus.swift
//  CounterStrikeTVDomain
//
//  Created by Victor Marcel on 15/07/25.
//

import Foundation

public enum MatchStatus: String, Codable, Sendable {
    
    // MARK: - CASES
    
    case notStarted = "not_started"
    case running
    case finished
    case postponed
    case canceled
}
