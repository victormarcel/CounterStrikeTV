//
//  NetworkingOperationsProtocol.swift
//  CounterStrikeTVService
//
//  Created by Victor Marcel on 28/05/25.
//

import Foundation

public protocol NetworkingOperationsProtocol: Sendable {
    
    func fetch(from url: String) async throws -> Data
    func fetch<T: Decodable>(request: HttpRequestProtocol) async throws -> T
}
