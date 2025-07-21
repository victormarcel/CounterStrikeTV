//
//  League.swift
//  CounterStrikeTVDomain
//
//  Created by Victor Marcel on 20/07/25.
//

import Foundation

public struct League: Decodable, Sendable {
    
    // MARK: - PUBLIC PROPERTIES
    
    public let id: Int
    public let name: String
    public let imageUrl: String?
    
    // MARK: - CODING KEYS
    
    public enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageUrl = "image_url"
    }
}
