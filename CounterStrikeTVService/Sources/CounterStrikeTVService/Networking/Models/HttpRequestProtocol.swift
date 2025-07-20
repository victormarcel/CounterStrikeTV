//
//  HttpRequestProtocol.swift
//  CounterStrikeTVService
//
//  Created by Victor Marcel on 27/05/25.
//

import CounterStrikeTVDomain
import Foundation

public protocol HttpRequestProtocol {
    
    var url: String { get }
    var method: HttpMethod { get }
    var parameters: [RequestParameter]? { get }
    var headers: [String: String]? { get }
}

public extension HttpRequestProtocol {
    
    func buildUrlRequest() throws -> URLRequest {
        var components = URLComponents(string: url)
        components?.queryItems = parameters?.compactMap { URLQueryItem(name: $0.key, value: String(describing: $0.value)) }
        
        guard let components, let url = components.url  else {
            throw NetworkingOperationsError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        // TODO: Change to a safe way
        request.setValue("Bearer aFrwSajvnEBCrnpSB89AeyKsE9dv2AGbTnEPPSu0QKVbpyez_aw", forHTTPHeaderField: "Authorization")
        return request
    }
}
