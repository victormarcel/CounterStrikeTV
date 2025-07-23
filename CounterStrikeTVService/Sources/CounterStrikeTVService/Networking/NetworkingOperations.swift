//
//  NetworkingOperations.swift
//  CounterStrikeTVService
//
//  Created by Victor Marcel on 27/05/25.
//

import Foundation

public final class NetworkingOperations: NetworkingOperationsProtocol {
    
    // MARK: - PRIVATE PROPERTIES
    
    private let session: URLSession
    
    // MARK: - INITIALIZERS
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - INTERNAL METHODS
    
    public func fetch(from url: String) async throws -> Data {
        do {
            guard let url = URL(string: url) else {
                throw NetworkingOperationsError.invalidUrl
            }
            
            let (data, _) = try await session.data(from: url)
            return data
        } catch let error {
            throw error
        }
    }
    
    public func fetch<T: Decodable>(request: HttpRequestProtocol) async throws -> T {
        do {
            let urlRequest = try buildUrlRequestFrom(requestData: request)
            let (data, _) = try await session.data(for: urlRequest)
            
            try? printPrettyResponse(data)
            
            let response: T = try decode(data: data)
            return response
        } catch let error {
            throw error
        }
    }
    
    // MARK: - PRIVATE METHOD
    
    private func buildUrlRequestFrom(requestData: HttpRequestProtocol) throws -> URLRequest {
        let url = try buildUrl(requestData: requestData)
        var urlRequest = URLRequest(url: url)
        addRequestHeaders(data: requestData, urlRequest: &urlRequest)
        return urlRequest
    }
    
    private func buildUrl(requestData: HttpRequestProtocol) throws -> URL {
        guard var components = URLComponents(string: requestData.url) else {
            throw NetworkingOperationsError.invalidUrl
        }
        
        if requestData.method == .get {
            components.queryItems = requestData.parameters?.compactMap {
                URLQueryItem(name: $0.key, value: String(describing: $0.value))
            }
        }
        
        guard let url = components.url else {
            throw NetworkingOperationsError.invalidUrl
        }
        
        return url
    }
    
    private func addRequestHeaders(data: HttpRequestProtocol, urlRequest: inout URLRequest) {
        data.headers?.forEach {
            urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
        }
    }
    
    private func decode<T: Decodable>(data: Data) throws -> T {
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch let error {
            throw NetworkingOperationsError.parseError(error)
        }
    }
    
    private func printPrettyResponse(_ data: Data) throws {
        let object = try JSONSerialization.jsonObject(with: data)
        let prettyPrintedData = try JSONSerialization.data(
            withJSONObject: object,
            options: [.prettyPrinted, .sortedKeys]
        )
        let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8)!
        print(prettyPrintedString)
    }
}
