//
//  ServiceRequestDataProtocol.swift
//  CounterStrikeTVDomain
//
//  Created by Victor Marcel on 19/07/25.
//

import Foundation

public typealias RequestParameter = (key: String, value: Any)

public protocol ServiceRequestDataProtocol {
    
    // MARK: - METHODS
    
    func buildParameters() -> [RequestParameter]?
    func buildHeaders() -> [String: String]?
}
