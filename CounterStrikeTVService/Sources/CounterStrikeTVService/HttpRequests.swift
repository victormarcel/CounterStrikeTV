//
//  HttpRequests.swift
//  CounterStrikeTVService
//
//  Created by Victor Marcel on 12/07/25.
//

import CounterStrikeTVDomain
import Foundation

enum HttpRequest: HttpRequestProtocol {
    
    // MARK: - CASES
    
    case fetchMatches(MatchesRequestData)
    case fetchTeam(TeamRequestData)
    
    // MARK: - INTERNAL PROPERTIES
    
    var url: String {
        switch self {
        case .fetchMatches:
            return PandaScoreConstants.Matches.url
        case .fetchTeam:
            return PandaScoreConstants.Teams.url
        }
    }
    
    var method: HttpMethod {
        return .get
    }
    
    var parameters: [(key: String, value: Any)]? {
        switch self {
        case .fetchMatches(let requestData):
            return requestData.buildParameters()
        case .fetchTeam(let requestData):
            return requestData.buildParameters()
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .fetchMatches(let requestData):
            return requestData.buildHeaders()
        case .fetchTeam(let requestData):
            return requestData.buildHeaders()
        }
    }
}
