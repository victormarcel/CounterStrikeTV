//
//  ServiceCredentials.swift
//  CounterStrikeTVService
//
//  Created by Victor Marcel on 19/07/25.
//

import Foundation

final class ServiceCredentials {
    
    // MARK: - CONSTANTS
    
    private enum Constants {
        
        static let credentialsFileName = "Config"
        static let jsonExtension = "json"
    }
    
    // MARK: - STRUCT's
    
    private struct CredentialsData: Codable {
        let pandaScoreApiKey: String
    }
    
    // MARK: - INTERNAL PROPERTIES
    
    var pandaScoreApiKey: String {
        return credentiaslData?.pandaScoreApiKey ?? .empty
    }
    
    // MARK: - PRIVATE PROPERTIES
    
    private var credentiaslData: CredentialsData?
    
    
    // MARK: - INITIALIZERS
    
    init() {
       decodeCredential()
    }
    
    // MARK: - PRIVATE METHODS
    
    private func decodeCredential() {
        let resource = Constants.credentialsFileName
        let withExtension = Constants.jsonExtension
        
        guard let url = Bundle.main.url(forResource: resource, withExtension: withExtension) else {
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            credentiaslData = try? JSONDecoder().decode(CredentialsData.self, from: data)
        } catch {
            return
        }
    }
}
