//
//  Services.swift
//  CounterStrikeTVService
//
//  Created by Victor Marcel on 12/07/25.
//

import CounterStrikeTVDomain

public final class Services: ServicesProtocol {
    
    // MARK: - PRIVATE PROPERTIES
    
    private let networkingOperations: NetworkingOperationsProtocol
    
    // MARK: - INITIALIZERS
    
    public init(networkingOperations: NetworkingOperationsProtocol) {
        self.networkingOperations = networkingOperations
    }
    
    // MARK: - INTERNAL METHODS
    
    public func fetchMatches(data: MatchesRequestData) async throws -> [Match] {
        let httpRequest = HttpRequest.fetchMatches(data)
        return try await networkingOperations.fetch(request: httpRequest)
    }
    
    public func fetchTeam(data: TeamRequestData) async throws -> Team {
        let httpRequest = HttpRequest.fetchTeam(data)
        do {
            let response: [Team] = try await networkingOperations.fetch(request: httpRequest)
            guard let team = response.first else {
                throw NetworkingOperationsError.dataNotFound
            }
            return team
        } catch let error {
            throw error
        }
    }
}
