//
//  NetworkingOperationsTests.swift
//  CounterStrikeTVServiceTests
//
//  Created by Victor Marcel on 12/07/25.
//

import XCTest
import CounterStrikeTVDomain
@testable import CounterStrikeTVService

final class NetworkingOperationsTests: XCTestCase {
    
    // MARK: - PRIVATE PROPERTIES
    
    private var mockURLSession: MockURLSession!
    private var networkingOperations: NetworkingOperations!
    
    // MARK: - LIFE CYCLE
    
    override func setUpWithError() throws {
        mockURLSession = MockURLSession()
        networkingOperations = NetworkingOperations(session: mockURLSession)
    }

    override func tearDownWithError() throws {
        mockURLSession = nil
        networkingOperations = nil
    }
    
    // MARK: - FETCH FROM URL TESTS
    
    func testFetchFromUrlSuccess() async throws {
        // Given
        let expectedData = "test data".data(using: .utf8)!
        let url = "https://example.com/test"
        mockURLSession.mockData = expectedData
        mockURLSession.mockResponse = HTTPURLResponse(
            url: URL(string: url)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When
        let result = try await networkingOperations.fetch(from: url)
        
        // Then
        XCTAssertEqual(result, expectedData)
        XCTAssertTrue(mockURLSession.dataFromUrlCalled)
    }
    
    func testFetchFromUrlInvalidUrl() async {
        // Given
        let invalidUrl = "invalid-url"
        
        // When & Then
        do {
            _ = try await networkingOperations.fetch(from: invalidUrl)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? NetworkingOperationsError, .invalidUrl)
        }
    }
    
    func testFetchFromUrlNetworkError() async {
        // Given
        let url = "https://example.com/test"
        mockURLSession.shouldThrowError = true
        
        // When & Then
        do {
            _ = try await networkingOperations.fetch(from: url)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
    
    // MARK: - FETCH REQUEST TESTS
    
    func testFetchRequestSuccess() async throws {
        // Given
        let expectedMatches = createMockMatches()
        let requestData = createMockHttpRequest()
        let responseData = try JSONEncoder().encode(expectedMatches)
        
        mockURLSession.mockData = responseData
        mockURLSession.mockResponse = HTTPURLResponse(
            url: URL(string: requestData.url)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When
        let result: [Match] = try await networkingOperations.fetch(request: requestData)
        
        // Then
        XCTAssertEqual(result.count, expectedMatches.count)
        XCTAssertEqual(result.first?.id, expectedMatches.first?.id)
        XCTAssertTrue(mockURLSession.dataForRequestCalled)
    }
    
    func testFetchRequestWithQueryParameters() async throws {
        // Given
        let requestData = createMockHttpRequestWithQueryParams()
        let responseData = try JSONEncoder().encode(createMockMatches())
        
        mockURLSession.mockData = responseData
        mockURLSession.mockResponse = HTTPURLResponse(
            url: URL(string: requestData.url)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When
        let result: [Match] = try await networkingOperations.fetch(request: requestData)
        
        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertTrue(mockURLSession.dataForRequestCalled)
    }
    
    func testFetchRequestWithHeaders() async throws {
        // Given
        let requestData = createMockHttpRequestWithHeaders()
        let responseData = try JSONEncoder().encode(createMockMatches())
        
        mockURLSession.mockData = responseData
        mockURLSession.mockResponse = HTTPURLResponse(
            url: URL(string: requestData.url)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When
        let result: [Match] = try await networkingOperations.fetch(request: requestData)
        
        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertTrue(mockURLSession.dataForRequestCalled)
    }
    
    func testFetchRequestInvalidUrl() async {
        // Given
        let requestData = createInvalidHttpRequest()
        
        // When & Then
        do {
            let _: [Match] = try await networkingOperations.fetch(request: requestData)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? NetworkingOperationsError, .invalidUrl)
        }
    }
    
    func testFetchRequestDecodingError() async {
        // Given
        let requestData = createMockHttpRequest()
        let invalidJsonData = "invalid json".data(using: .utf8)!
        
        mockURLSession.mockData = invalidJsonData
        mockURLSession.mockResponse = HTTPURLResponse(
            url: URL(string: requestData.url)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When & Then
        do {
            let _: [Match] = try await networkingOperations.fetch(request: requestData)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkingOperationsError)
        }
    }
    
    func testFetchRequestNetworkError() async {
        // Given
        let requestData = createMockHttpRequest()
        mockURLSession.shouldThrowError = true
        
        // When & Then
        do {
            let _: [Match] = try await networkingOperations.fetch(request: requestData)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
    
    // MARK: - PRIVATE METHODS
    
    private func createMockMatches() -> [Match] {
        return [
            Match(
                id: 1,
                opponents: [
                    Match.OpponentData(opponent: Team(id: 1, name: "Team A", imageUrl: nil, players: nil))
                ],
                beginAt: "2024-01-01T10:00:00Z",
                status: .running,
                league: League(id: 1, name: "League A", imageUrl: nil),
                serie: Serie(id: 1, name: "Serie A", fullName: "Full Serie A")
            ),
            Match(
                id: 2,
                opponents: [
                    Match.OpponentData(opponent: Team(id: 2, name: "Team B", imageUrl: nil, players: nil))
                ],
                beginAt: "2024-01-01T12:00:00Z",
                status: .finished,
                league: League(id: 2, name: "League B", imageUrl: nil),
                serie: Serie(id: 2, name: "Serie B", fullName: "Full Serie B")
            )
        ]
    }
    
    private func createMockHttpRequest() -> HttpRequestProtocol {
        return MockHttpRequest(
            url: "https://api.pandascore.co/matches",
            method: .get,
            parameters: ["page": 1],
            headers: nil
        )
    }
    
    private func createMockHttpRequestWithQueryParams() -> HttpRequestProtocol {
        return MockHttpRequest(
            url: "https://api.pandascore.co/matches",
            method: .get,
            parameters: ["page": 1, "per_page": 10],
            headers: nil
        )
    }
    
    private func createMockHttpRequestWithHeaders() -> HttpRequestProtocol {
        return MockHttpRequest(
            url: "https://api.pandascore.co/matches",
            method: .get,
            parameters: ["page": 1],
            headers: ["Authorization": "Bearer token123"]
        )
    }
    
    private func createInvalidHttpRequest() -> HttpRequestProtocol {
        return MockHttpRequest(
            url: "invalid-url",
            method: .get,
            parameters: nil,
            headers: nil
        )
    }
}

// MARK: - Mock URL Session

private final class MockURLSession: URLSession {
    
    // MARK: - PRIVATE PROPERTIES
    
    var mockData: Data = Data()
    var mockResponse: URLResponse?
    var shouldThrowError = false
    var dataFromUrlCalled = false
    var dataForRequestCalled = false
    
    // MARK: - INTERNAL METHODS
    
    override func data(from url: URL) async throws -> (Data, URLResponse) {
        dataFromUrlCalled = true
        
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        
        return (mockData, mockResponse ?? HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!)
    }
    
    override func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        dataForRequestCalled = true
        
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        
        return (mockData, mockResponse ?? HTTPURLResponse(
            url: request.url!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!)
    }
}

// MARK: - Mock HTTP Request

private struct MockHttpRequest: HttpRequestProtocol {
    let url: String
    let method: HttpMethod
    let parameters: [String: Any]?
    let headers: [String: String]?
} 