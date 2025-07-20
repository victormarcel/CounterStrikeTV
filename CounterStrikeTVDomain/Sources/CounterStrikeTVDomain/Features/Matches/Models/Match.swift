//
//  Match.swift
//  CounterStrikeTVDomain
//
//  Created by Victor Marcel on 12/07/25.
//

public struct Match: Decodable, Sendable {
    
    // MARK: - PUBLIC PROPERTIES
    
    public let id: Int
    public let opponents: [OpponentData]
    public let beginAt: String
    public let status: MatchStatus
    
    // MARK: - CODING KEYS
    
    public enum CodingKeys: String, CodingKey {
        case id
        case opponents
        case beginAt = "begin_at"
        case status
    }
    
    // MARK: - OPPONENT DATA
    
    public struct OpponentData: Decodable, Sendable {
        
        // MARK: - PUBLIC PROPERTIES
        
        public let opponent: Team
    }
}
