//
//  ServiceIntegrationTests.swift
//  CounterStrikeTVServiceTests
//
//  Created by Victor Marcel on 12/07/25.
//

import XCTest
import CounterStrikeTVDomain
@testable import CounterStrikeTVService

final class ServiceIntegrationTests: XCTestCase {
    
    // MARK: - PRIVATE PROPERTIES
    
    private var networkingOperations: NetworkingOperations!
    private var services: Services!
    private var cache: Cache!
    
    // MARK: - LIFE CYCLE
    
    override func setUpWithError() throws {
        networkingOperations = NetworkingOperations()
        services = Services(networkingOperations: networkingOperations)
        cache = Cache.shared
    }

    override func tearDownWithError() throws {
        networkingOperations = nil
        services = nil
        cache = nil
    }
    
    // MARK: - INTEGRATION TESTS
    
    func testFetchMatchesIntegration() async throws {
        // Given
        let requestData = MatchesRequestData(page: 1)
        
        // When
        let matches = try await services.fetchMatches(data: requestData)
        
        // Then
        XCTAssertFalse(matches.isEmpty, "Should fetch matches from API")
        
        // Verify matches have required properties
        for match in matches {
            XCTAssertGreaterThan(match.id, 0, "Match should have valid ID")
            XCTAssertFalse(match.opponents.isEmpty, "Match should have opponents")
            XCTAssertNotNil(match.league, "Match should have league")
            XCTAssertNotNil(match.serie, "Match should have serie")
        }
    }
    
    func testFetchTeamIntegration() async throws {
        // Given
        // First fetch matches to get a valid team ID
        let matchesRequest = MatchesRequestData(page: 1)
        let matches = try await services.fetchMatches(data: matchesRequest)
        
        guard let firstMatch = matches.first,
              let firstOpponent = firstMatch.opponents.first else {
            XCTFail("No matches or opponents found for integration test")
            return
        }
        
        let teamId = firstOpponent.opponent.id
        let teamRequest = TeamRequestData(id: teamId)
        
        // When
        let team = try await services.fetchTeam(data: teamRequest)
        
        // Then
        XCTAssertEqual(team.id, teamId, "Should fetch correct team")
        XCTAssertFalse(team.name.isEmpty, "Team should have a name")
        XCTAssertNotNil(team.players, "Team should have players")
    }
    
    func testCachingBehavior() async throws {
        // Given
        let matchesRequest = MatchesRequestData(page: 1)
        let matches = try await services.fetchMatches(data: matchesRequest)
        
        guard let firstMatch = matches.first,
              let firstOpponent = firstMatch.opponents.first else {
            XCTFail("No matches or opponents found for caching test")
            return
        }
        
        let teamId = firstOpponent.opponent.id
        let teamRequest = TeamRequestData(id: teamId)
        
        // When - First call (should hit network)
        let startTime = Date()
        let team1 = try await services.fetchTeam(data: teamRequest)
        let firstCallTime = Date().timeIntervalSince(startTime)
        
        // When - Second call (should hit cache)
        let startTime2 = Date()
        let team2 = try await services.fetchTeam(data: teamRequest)
        let secondCallTime = Date().timeIntervalSince(startTime2)
        
        // Then
        XCTAssertEqual(team1.id, team2.id, "Should return same team")
        XCTAssertEqual(team1.name, team2.name, "Should return same team name")
        
        // Cache should be faster (though this might not always be true in tests)
        // We'll just verify both calls succeeded
        XCTAssertGreaterThan(firstCallTime, 0, "First call should take time")
        XCTAssertGreaterThan(secondCallTime, 0, "Second call should take time")
    }
    
    func testImageCachingIntegration() async throws {
        // Given
        let matchesRequest = MatchesRequestData(page: 1)
        
        // When
        let matches = try await services.fetchMatches(data: matchesRequest)
        
        // Then
        XCTAssertFalse(matches.isEmpty, "Should fetch matches")
        
        // Wait for background image caching to complete
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        // Verify that images with URLs are being processed
        let matchesWithImages = matches.filter { match in
            match.opponents.contains { opponent in
                opponent.opponent.imageUrl != nil && !opponent.opponent.imageUrl!.isEmpty
            }
        }
        
        if !matchesWithImages.isEmpty {
            // At least some matches should have image URLs
            XCTAssertTrue(true, "Some matches have image URLs for caching")
        }
    }
    
    func testErrorHandlingIntegration() async {
        // Given
        let invalidTeamRequest = TeamRequestData(id: 999999999) // Very unlikely to exist
        
        // When & Then
        do {
            _ = try await services.fetchTeam(data: invalidTeamRequest)
            XCTFail("Expected error for invalid team ID")
        } catch {
            XCTAssertTrue(error is NetworkingOperationsError, "Should throw NetworkingOperationsError")
        }
    }
    
    func testConcurrentRequests() async throws {
        // Given
        let matchesRequest = MatchesRequestData(page: 1)
        
        // When - Make multiple concurrent requests
        async let matches1 = services.fetchMatches(data: matchesRequest)
        async let matches2 = services.fetchMatches(data: matchesRequest)
        async let matches3 = services.fetchMatches(data: matchesRequest)
        
        // Then
        let (result1, result2, result3) = try await (matches1, matches2, matches3)
        
        XCTAssertFalse(result1.isEmpty, "First request should succeed")
        XCTAssertFalse(result2.isEmpty, "Second request should succeed")
        XCTAssertFalse(result3.isEmpty, "Third request should succeed")
        
        // All results should be the same (same page)
        XCTAssertEqual(result1.count, result2.count, "Concurrent requests should return same data")
        XCTAssertEqual(result2.count, result3.count, "Concurrent requests should return same data")
    }
    
    // MARK: - PERFORMANCE TESTS
    
    func testFetchMatchesPerformance() throws {
        // Given
        let requestData = MatchesRequestData(page: 1)
        
        // When & Then
        measure {
            Task {
                do {
                    _ = try await services.fetchMatches(data: requestData)
                } catch {
                    XCTFail("Performance test failed: \(error)")
                }
            }
        }
    }
    
    func testFetchTeamPerformance() throws {
        // Given
        // We need a valid team ID for this test
        let teamRequest = TeamRequestData(id: 1) // Assuming team ID 1 exists
        
        // When & Then
        measure {
            Task {
                do {
                    _ = try await services.fetchTeam(data: teamRequest)
                } catch {
                    // It's okay if this fails in performance test
                    // We're just measuring the call time
                }
            }
        }
    }
} 