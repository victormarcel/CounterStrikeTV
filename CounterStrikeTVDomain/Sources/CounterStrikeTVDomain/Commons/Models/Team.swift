//
//  Team.swift
//  CounterStrikeTVDomain
//
//  Created by Victor Marcel on 12/07/25.
//

import Foundation

public struct Team: Decodable, Sendable {
    
    // MARK: - PUBLIC PROPERTIES
    
    public let name: String
    public let imageUrl: String?
    
    // MARK: - CODING KEYS
    
    private enum CodingKeys: String, CodingKey {
        case name
        case imageUrl = "image_url"
    }
}
