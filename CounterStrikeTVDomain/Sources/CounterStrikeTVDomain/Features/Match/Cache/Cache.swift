//
//  Cache.swift
//  CounterStrikeTVDomain
//
//  Created by Victor Marcel on 21/07/25.
//

import SwiftUI
import Foundation

public enum CacheError: Error {
    case invalidValueType
}

public class Cache: @unchecked Sendable {
    
    // MARK: - CLASSES
    
    
    
    // MARK: - STATIC PROPERTIES
    
    public static let shared = Cache()
    
    // MARK: - PRIVATE PROPERTIES
    
    private let images = NSCache<NSString, CacheObject<Image>>()
    private let teams = NSCache<NSString, CacheObject<Team>>()
    
    // MARK: - INITIALIZERS
    
    private init() {}
    
    // MARK: - PUBLIC METHODS
    
    public func storeImage<T>(_ value: T, forKey key: String) throws {
        switch value {
        case let image as Image:
            images.setObject(.init(image), forKey: key as NSString)
        case let data as Data:
            guard let uiImage = UIImage(data: data) else { return }
            images.setObject(.init(Image(uiImage: uiImage)), forKey: key as NSString)
        default:
            throw CacheError.invalidValueType
        }
    }
    
    public func image(forKey key: String) -> Image? {
        return images.object(forKey: key as NSString)?.value
    }
    
    public func storeTeam(_ team: Team, forKey key: String) throws {
        teams.setObject(.init(team), forKey: key as NSString)
    }
    
    public func team(forKey key: String) -> Team? {
        return teams.object(forKey: key as NSString)?.value
    }
}
