//
//  TestHelpers.swift
//  CounterStrikeTVServiceTests
//
//  Created by Victor Marcel on 12/07/25.
//

import XCTest
import CounterStrikeTVDomain
@testable import CounterStrikeTVService

// MARK: - Test Helpers

extension XCTestCase {
    
    // MARK: - Mock Data Creators
    
    func createMockMatch(id: Int = 1, teamCount: Int = 2) -> Match {
        let opponents = (1...teamCount).map { teamId in
            Match.OpponentData(
                opponent: Team(
                    id: teamId,
                    name: "Team \(teamId)",
                    imageUrl: "https://example.com/team\(teamId).png",
                    players: createMockPlayers(forTeam: teamId)
                )
            )
        }
        
        return Match(
            id: id,
            opponents: opponents,
            beginAt: "2024-01-01T10:00:00Z",
            status: .running,
            league: League(id: 1, name: "League A", imageUrl: nil),
            serie: Serie(id: 1, name: "Serie A", fullName: "Full Serie A")
        )
    }
    
    func createMockMatches(count: Int = 2) -> [Match] {
        return (1...count).map { createMockMatch(id: $0) }
    }
    
    func createMockTeam(id: Int = 123, playerCount: Int = 3) -> Team {
        return Team(
            id: id,
            name: "Mock Team \(id)",
            imageUrl: "https://example.com/team\(id).png",
            players: createMockPlayers(forTeam: id, count: playerCount)
        )
    }
    
    func createMockPlayers(forTeam teamId: Int, count: Int = 3) -> [Player] {
        return (1...count).map { playerId in
            Player(
                id: playerId,
                firstName: "Player\(playerId)",
                lastName: "Team\(teamId)",
                name: "Player\(playerId) Team\(teamId)",
                slug: "player\(playerId)-team\(teamId)",
                imageUrl: "https://example.com/player\(playerId).png"
            )
        }
    }
    
    func createMockHttpRequest(
        url: String = "https://api.pandascore.co/matches",
        method: HttpMethod = .get,
        parameters: [String: Any]? = ["page": 1],
        headers: [String: String]? = nil
    ) -> HttpRequestProtocol {
        return MockHttpRequest(
            url: url,
            method: method,
            parameters: parameters,
            headers: headers
        )
    }
    
    // MARK: - Assertion Helpers
    
    func XCTAssertMatchesEqual(_ match1: Match, _ match2: Match, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(match1.id, match2.id, "Match IDs should be equal", file: file, line: line)
        XCTAssertEqual(match1.opponents.count, match2.opponents.count, "Match opponents count should be equal", file: file, line: line)
        XCTAssertEqual(match1.league.id, match2.league.id, "Match league IDs should be equal", file: file, line: line)
        XCTAssertEqual(match1.serie.id, match2.serie.id, "Match serie IDs should be equal", file: file, line: line)
    }
    
    func XCTAssertTeamsEqual(_ team1: Team, _ team2: Team, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(team1.id, team2.id, "Team IDs should be equal", file: file, line: line)
        XCTAssertEqual(team1.name, team2.name, "Team names should be equal", file: file, line: line)
        XCTAssertEqual(team1.imageUrl, team2.imageUrl, "Team image URLs should be equal", file: file, line: line)
        XCTAssertEqual(team1.players?.count, team2.players?.count, "Team players count should be equal", file: file, line: line)
    }
    
    // MARK: - Async Helpers
    
    func waitForAsyncOperation(timeout: TimeInterval = 5.0) async throws {
        try await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
    }
    
    func measureAsyncOperation<T>(_ operation: () async throws -> T) async throws -> (T, TimeInterval) {
        let startTime = Date()
        let result = try await operation()
        let duration = Date().timeIntervalSince(startTime)
        return (result, duration)
    }
}

// MARK: - Mock HTTP Request

struct MockHttpRequest: HttpRequestProtocol {
    let url: String
    let method: HttpMethod
    let parameters: [String: Any]?
    let headers: [String: String]?
}

// MARK: - Test Constants

enum TestConstants {
    
    // MARK: - Timeouts
    
    static let shortTimeout: TimeInterval = 1.0
    static let mediumTimeout: TimeInterval = 5.0
    static let longTimeout: TimeInterval = 10.0
    
    // MARK: - Test Data
    
    static let validTeamId = 123
    static let invalidTeamId = 999999999
    static let validPage = 1
    static let invalidPage = -1
    
    // MARK: - URLs
    
    static let validUrl = "https://api.pandascore.co/matches"
    static let invalidUrl = "invalid-url"
    static let imageUrl = "https://example.com/test-image.png"
    
    // MARK: - Error Messages
    
    static let expectedErrorMessage = "Expected error to be thrown"
    static let unexpectedSuccessMessage = "Expected success but got error"
} 