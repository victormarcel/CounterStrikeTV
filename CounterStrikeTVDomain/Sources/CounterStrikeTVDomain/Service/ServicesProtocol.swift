//
//  ServicesProtocol.swift
//  CounterStrikeTVDomain
//
//  Created by Victor Marcel on 12/07/25.
//

public protocol ServicesProtocol: Sendable {
    
    func fetchMatches(data: MatchesRequestData) async throws -> [Match]
}
