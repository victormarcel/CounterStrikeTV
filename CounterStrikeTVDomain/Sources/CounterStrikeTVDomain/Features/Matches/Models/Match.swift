//
//  Match.swift
//  CounterStrikeTVDomain
//
//  Created by Victor Marcel on 12/07/25.
//

public struct Match: Decodable, Sendable {
    
    // MARK: - CONSTANTS
    
    private enum Constants {
        
        static let plusSymbol = "+"
        static let dashSymbol = "-"
    }
    
    // MARK: - PUBLIC PROPERTIES
    
    public let id: Int
    public let opponents: [OpponentData]
    public let beginAt: String?
    public let status: MatchStatus
    public let league: League
    public let serie: Serie
    
    public var description: String {
        return [league.name, serie.fullName].joined(separator: " \(Constants.plusSymbol) ")
    }
    
    public var beginAtDescription: String {
        guard let matchBeginDate = beginAt?.dateBy(format: .utc) else {
            return Constants.dashSymbol
        }
        
        return matchBeginDate.dateAbbreviationDescription
    }
    
    // MARK: - CODING KEYS
    
    public enum CodingKeys: String, CodingKey {
        case id
        case opponents
        case beginAt = "begin_at"
        case status
        case league
        case serie
    }
    
    // MARK: - OPPONENT DATA
    
    public struct OpponentData: Decodable, Sendable {
        
        // MARK: - PUBLIC PROPERTIES
        
        public let opponent: Team
    }
}
