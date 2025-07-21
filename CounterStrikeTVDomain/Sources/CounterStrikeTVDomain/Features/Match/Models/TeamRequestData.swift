//
//  TeamRequestData.swift
//  CounterStrikeTVDomain
//
//  Created by Victor Marcel on 20/07/25.
//

import Foundation

public struct TeamRequestData: ServiceRequestDataProtocol {
    
    // MARK: - CONSTANTS
    
    private enum Constants {
        
        enum Header {
            static let authorization = "Authorization"
        }
    }
    
    // MARK: - PUBLIC PROPERTIES
    
    public let id: Int
    
    // MARK: - INITIALIZERS
    
    public init(id: Int) {
        self.id = id
    }
    
    // MARK: - PRIVATE METHODS
    
    private var idParameter: RequestParameter {
        let key = buildArrayFormatParameter(
            key: PandaScoreConstants.Parameter.filter,
            value: PandaScoreConstants.Parameter.id
        )
        return (key: key, value: id)
    }
    
    private func buildArrayFormatParameter(key: String, value: CVarArg) -> String {
        String(format: PandaScoreConstants.Parameter.arrayFormat, key, value)
    }
    
    // MARK: - PUBLIC METHODS
    
    public func buildParameters() -> [RequestParameter]? {
        [idParameter]
    }
    
    public func buildHeaders() -> [String: String]? {
        [Constants.Header.authorization: ServiceCredentials().pandaScoreApiAuthorization]
    }
}
