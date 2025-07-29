//
//  CounterStrikeTVServiceTests.swift
//  CounterStrikeTVServiceTests
//
//  Created by Victor Marcel on 12/07/25.
//

import XCTest
import CounterStrikeTVDomain
@testable import CounterStrikeTVService

final class CounterStrikeTVServiceTests: XCTestCase {
    
    // MARK: - PRIVATE PROPERTIES
    
    private var mockNetworkingOperations: MockNetworkingOperations!
    private var services: Services!
    private var cache: Cache!
    
    // MARK: - LIFE CYCLE
    
    override func setUpWithError() throws {
        mockNetworkingOperations = MockNetworkingOperations()
        services = Services(networkingOperations: mockNetworkingOperations)
        cache = Cache.shared
    }

    override func tearDownWithError() throws {
        mockNetworkingOperations = nil
        services = nil
        cache = nil
    }
    
    // MARK: - FETCH MATCHES TESTS
    
    func testFetchMatchesSuccess() async throws {
        // Given
        let expectedMatches = createMockMatches()
        mockNetworkingOperations.mockMatches = expectedMatches
        let requestData = MatchesRequestData(page: 1)
        
        // When
        let result = try await services.fetchMatches(data: requestData)
        
        // Then
        XCTAssertEqual(result.count, expectedMatches.count)
        XCTAssertEqual(result.first?.id, expectedMatches.first?.id)
        XCTAssertTrue(mockNetworkingOperations.fetchRequestCalled)
    }
    
    func testFetchMatchesFailure() async {
        // Given
        mockNetworkingOperations.shouldThrowError = true
        let requestData = MatchesRequestData(page: 1)
        
        // When & Then
        do {
            _ = try await services.fetchMatches(data: requestData)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkingOperationsError)
        }
    }
    
    func testFetchMatchesCachesImages() async throws {
        // Given
        let matches = createMockMatchesWithImages()
        mockNetworkingOperations.mockMatches = matches
        mockNetworkingOperations.mockImageData = Data()
        let requestData = MatchesRequestData(page: 1)
        
        // When
        _ = try await services.fetchMatches(data: requestData)
        
        // Then
        // Wait a bit for background tasks to complete
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Verify that images were cached (this is indirect since we can't easily test the private method)
        XCTAssertTrue(mockNetworkingOperations.fetchFromUrlCalled)
    }
    
    // MARK: - FETCH TEAM TESTS
    
    func testFetchTeamSuccessFromCache() async throws {
        // Given
        let team = createMockTeam()
        let teamId = team.id
        try cache.storeTeam(team, forKey: String(teamId))
        let requestData = TeamRequestData(id: teamId)
        
        // When
        let result = try await services.fetchTeam(data: requestData)
        
        // Then
        XCTAssertEqual(result.id, teamId)
        XCTAssertFalse(mockNetworkingOperations.fetchRequestCalled, "Should not call network when cached")
    }
    
    func testFetchTeamSuccessFromNetwork() async throws {
        // Given
        let team = createMockTeam()
        mockNetworkingOperations.mockTeams = [team]
        let requestData = TeamRequestData(id: team.id)
        
        // When
        let result = try await services.fetchTeam(data: requestData)
        
        // Then
        XCTAssertEqual(result.id, team.id)
        XCTAssertTrue(mockNetworkingOperations.fetchRequestCalled)
    }
    
    func testFetchTeamFailureWhenNoTeamFound() async {
        // Given
        mockNetworkingOperations.mockTeams = []
        let requestData = TeamRequestData(id: 123)
        
        // When & Then
        do {
            _ = try await services.fetchTeam(data: requestData)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? NetworkingOperationsError, .dataNotFound)
        }
    }
    
    func testFetchTeamFailure() async {
        // Given
        mockNetworkingOperations.shouldThrowError = true
        let requestData = TeamRequestData(id: 123)
        
        // When & Then
        do {
            _ = try await services.fetchTeam(data: requestData)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkingOperationsError)
        }
    }
    
    func testFetchTeamCachesResult() async throws {
        // Given
        let team = createMockTeam()
        mockNetworkingOperations.mockTeams = [team]
        let requestData = TeamRequestData(id: team.id)
        
        // When
        let result = try await services.fetchTeam(data: requestData)
        
        // Then
        XCTAssertEqual(result.id, team.id)
        
        // Verify it's cached by calling again
        let cachedResult = try await services.fetchTeam(data: requestData)
        XCTAssertEqual(cachedResult.id, team.id)
        XCTAssertEqual(mockNetworkingOperations.fetchRequestCallCount, 1, "Should only call network once")
    }
    
    // MARK: - PRIVATE METHODS
    
    private func createMockMatches() -> [Match] {
        return [
            Match(
                id: 1,
                opponents: [
                    Match.OpponentData(opponent: Team(id: 1, name: "Team A", imageUrl: "https://example.com/team1.png", players: nil))
                ],
                beginAt: "2024-01-01T10:00:00Z",
                status: .running,
                league: League(id: 1, name: "League A", imageUrl: nil),
                serie: Serie(id: 1, name: "Serie A", fullName: "Full Serie A")
            ),
            Match(
                id: 2,
                opponents: [
                    Match.OpponentData(opponent: Team(id: 2, name: "Team B", imageUrl: "https://example.com/team2.png", players: nil))
                ],
                beginAt: "2024-01-01T12:00:00Z",
                status: .finished,
                league: League(id: 2, name: "League B", imageUrl: nil),
                serie: Serie(id: 2, name: "Serie B", fullName: "Full Serie B")
            )
        ]
    }
    
    private func createMockMatchesWithImages() -> [Match] {
        return [
            Match(
                id: 1,
                opponents: [
                    Match.OpponentData(opponent: Team(id: 1, name: "Team A", imageUrl: "https://example.com/team1.png", players: nil)),
                    Match.OpponentData(opponent: Team(id: 2, name: "Team B", imageUrl: "https://example.com/team2.png", players: nil))
                ],
                beginAt: "2024-01-01T10:00:00Z",
                status: .running,
                league: League(id: 1, name: "League A", imageUrl: nil),
                serie: Serie(id: 1, name: "Serie A", fullName: "Full Serie A")
            )
        ]
    }
    
    private func createMockTeam() -> Team {
        return Team(
            id: 123,
            name: "Mock Team",
            imageUrl: "https://example.com/team.png",
            players: [
                Player(
                    id: 1,
                    firstName: "John",
                    lastName: "Doe",
                    name: "John Doe",
                    slug: "john-doe",
                    imageUrl: "https://example.com/player.png"
                )
            ]
        )
    }
}

// MARK: - Mock Networking Operations

private final class MockNetworkingOperations: NetworkingOperationsProtocol {
    
    // MARK: - PRIVATE PROPERTIES
    
    var mockMatches: [Match] = []
    var mockTeams: [Team] = []
    var mockImageData: Data = Data()
    var shouldThrowError = false
    var fetchRequestCalled = false
    var fetchFromUrlCalled = false
    var fetchRequestCallCount = 0
    
    // MARK: - INTERNAL METHODS
    
    func fetch(from url: String) async throws -> Data {
        fetchFromUrlCalled = true
        
        if shouldThrowError {
            throw NetworkingOperationsError.invalidUrl
        }
        
        return mockImageData
    }
    
    func fetch<T: Decodable>(request: HttpRequestProtocol) async throws -> T {
        fetchRequestCalled = true
        fetchRequestCallCount += 1
        
        if shouldThrowError {
            throw NetworkingOperationsError.invalidUrl
        }
        
        if T.self == [Match].self {
            return mockMatches as! T
        } else if T.self == [Team].self {
            return mockTeams as! T
        } else {
            throw NetworkingOperationsError.dataNotFound
        }
    }
}
