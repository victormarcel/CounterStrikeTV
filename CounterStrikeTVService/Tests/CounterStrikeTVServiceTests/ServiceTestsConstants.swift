//
//  ServiceTestsConstants.swift
//  CounterStrikeTVServiceTests
//
//  Created by Victor Marcel on 12/07/25.
//

import Foundation

enum ServiceTestsConstants {
    
    // MARK: - API URLs
    
    static let baseApiUrl = "https://api.pandascore.co"
    static let matchesEndpoint = "/matches"
    static let teamsEndpoint = "/teams"
    
    // MARK: - Test Data
    
    static let validApiKey = "test-api-key-123"
    static let testTeamId = 123
    static let testMatchId = 456
    static let testPage = 1
    
    // MARK: - Mock Responses
    
    static let mockMatchesResponse = """
    [
        {
            "id": 1,
            "opponents": [
                {
                    "opponent": {
                        "id": 1,
                        "name": "Team A",
                        "image_url": "https://example.com/team1.png"
                    }
                }
            ],
            "begin_at": "2024-01-01T10:00:00Z",
            "status": "running",
            "league": {
                "id": 1,
                "name": "League A",
                "image_url": null
            },
            "serie": {
                "id": 1,
                "name": "Serie A",
                "full_name": "Full Serie A"
            }
        }
    ]
    """
    
    static let mockTeamResponse = """
    [
        {
            "id": 123,
            "name": "Mock Team",
            "image_url": "https://example.com/team.png",
            "players": [
                {
                    "id": 1,
                    "first_name": "John",
                    "last_name": "Doe",
                    "name": "John Doe",
                    "slug": "john-doe",
                    "image_url": "https://example.com/player.png"
                }
            ]
        }
    ]
    """
    
    // MARK: - Error Messages
    
    static let invalidUrlErrorMessage = "Invalid URL provided"
    static let dataNotFoundErrorMessage = "No data found for the given request"
    static let networkErrorMessage = "Network request failed"
    static let decodingErrorMessage = "Failed to decode response data"
} 