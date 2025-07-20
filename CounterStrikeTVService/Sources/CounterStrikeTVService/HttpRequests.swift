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
    
    // MARK: - INTERNAL PROPERTIES
    
    var url: String {
        switch self {
        case .fetchMatches:
            return PandaScoreConstants.Matches.url
        }
    }
    
    var method: HttpMethod {
        return .get
    }
    
    var parameters: [(key: String, value: Any)]? {
        switch self {
        case .fetchMatches(let requestData):
            return requestData.buildParameters()
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .fetchMatches(let requestData):
            return requestData.buildHeaders()
        }
    }
    
//    var url: String {
//        return "https://api.pandascore.co/csgo/matches?sort=-status,begin_at&range[begin_at]=2025-07-12T11:00:00Z,2025-12-31T11:00:00Z&page[size]=10&page=1&filter[status]=not_started, running"
//    }
    
   
}
