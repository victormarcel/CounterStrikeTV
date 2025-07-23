//
//  CacheTestes.swift
//  CounterStrikeTVDomain
//
//  Created by Victor Marcel on 22/07/25.
//

import SwiftUI
import XCTest

@testable import CounterStrikeTVDomain

final class CacheTestes: XCTestCase {
    
    // MARK: - CONSTANTS
    
    private enum Constants {
        
    }
    
    // MARK: - PRIVATE PROPERTIES
    
    private let cache = Cache.shared
    
    // MARK: - INTERNAL METHODS
    
    func testStoreAndRetrieveImage() throws {
        let image = Image(systemName: "star")
        let key = "link_image"

        try cache.storeImage(image, forKey: key)
        let cachedImage = cache.image(forKey: key)
        
        XCTAssertNotNil(cachedImage)
    }
    
    func testStoreImageFromData() throws {
        let uiImage = UIImage(systemName: "star.fill")!
        let data = uiImage.pngData()
        let key = "link_image"

        try cache.storeImage(data, forKey: key)
        let image = cache.image(forKey: key)

        XCTAssertNotNil(image)
    }
    
    func testStoreImageWithInvalidTypeThrows() {
        XCTAssertThrowsError(try cache.storeImage(123, forKey: "link_image")) { error in
            XCTAssertEqual(error as? CacheError, .invalidValueType)
        }
    }
    
    func testStoreAndRetrieveTeam() throws {
        guard let team = getTeam() else {
            XCTFail("Error to create team instance")
            return
        }
        let key = String(team.id)

        try cache.storeTeam(team, forKey: key)
        let cachedTeam = cache.team(forKey: key)

        XCTAssertEqual(String(cachedTeam?.id ?? .zero), key)
    }
    
    // MARK: - PRIVATE METHODS
    
    private func getTeam() -> Team? {
        let url = Bundle.testModule.url(forResource: DomainTestsConstants.playerResponseFileName, withExtension: "json")
        guard let url else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let response = try JSONDecoder().decode(Team.self, from: data)
            return response
        } catch {
            return nil
        }
    }
}

