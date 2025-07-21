//
//  Player.swift
//  CounterStrikeTVDomain
//
//  Created by Victor Marcel on 20/07/25.
//

import Foundation

public struct Player: Decodable, Sendable {
    
    // MARK: - PUBLIC PROPERTIES
    
    public let id: Int
    public let firstName: String?
    public let lastName: String?
    public let name: String
    public let slug: String
    public let imageUrl: String?
    
    // MARK: - CODING KEYS
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case name
        case slug
        case imageUrl = "image_url"
    }
}
