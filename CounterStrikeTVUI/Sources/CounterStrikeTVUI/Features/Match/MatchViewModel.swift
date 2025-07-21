//
//  MatchViewModel.swift
//  CounterStrikeTVUI
//
//  Created by Victor Marcel on 20/07/25.
//

import Combine
import CounterStrikeTVDomain
import Foundation

@MainActor
public class MatchViewModel: ObservableObject {
    
    // MARK: - PRIVATE PROPERTIES
    
    private let service: ServicesProtocol
    private let matchServicePassthrough = PassthroughSubject<ViewState<Void>, Never>()
    
    // MARK: - INTERNAL PROPERTIES
    
    @Published var opponents: [Team] = []
    let match: Match
    
    var matchServicePublisher: AnyPublisher<ViewState<Void>, Never> {
        matchServicePassthrough.eraseToAnyPublisher()
    }
    
    // MARK: - INITIALIZER
    
    public init(match: Match, service: ServicesProtocol) {
        self.match = match
        self.service = service
    }
    
    // MARK: - INTERNAL METHODS
    
    func fetchTeams() async {
        matchServicePassthrough.send(.loading)
        do {
            opponents = try await performMatchTeamsTaskGroud()
            sortTeamsByMatchOrder()
            
            matchServicePassthrough.send(.success(()))
        } catch {
            matchServicePassthrough.send(.error)
        }
    }
    
    private func sortTeamsByMatchOrder() {
        var sortedTeams: [Team] = []
        match.opponents.forEach { matchTeam in
            if let team = opponents.first(where: { $0.id == matchTeam.opponent.id }) {
                sortedTeams.append(team)
            }
        }
        
        opponents = sortedTeams
    }
    
    // MARK: - PRIVATE METHODS
    
    private func performMatchTeamsTaskGroud() async throws -> [Team] {
        return await withTaskGroup(
            of: Team?.self,
            returning: [Team].self
        ) { [weak self] taskGroup in
            guard let self else {
                return []
            }
            
            let opponents = match.opponents.map { $0.opponent }
            for team in opponents {
                taskGroup.addTask {
                    do {
                        return try await self.service.fetchTeam(data: .init(id: team.id))
                    } catch {
                        return nil
                    }
                }
            }
            
            var teams: [Team] = []
            for await team in taskGroup {
                if let team {
                    teams.append(team)
                }
            }
            return teams
        }
    }
}

