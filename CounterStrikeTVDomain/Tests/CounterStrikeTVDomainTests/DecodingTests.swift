//
//  DecodingTests.swift
//  CounterStrikeTVDomain
//
//  Created by Victor Marcel on 22/07/25.
//

import XCTest

@testable import CounterStrikeTVDomain

final class DecodingTests: XCTestCase {
    
    // MARK: - LIFE CICLE
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
    
    // MARK: - INTERNAL METHODS
    
    func testMatchesDecoding() throws {
        let url = Bundle.testModule.url(forResource: DomainTestsConstants.matchesResponseFileName, withExtension: "json")
        guard let url else {
            XCTFail("Missing file: \(DomainTestsConstants.matchesResponseFileName).json")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let response = try JSONDecoder().decode([Match].self, from: data)
            XCTAssertTrue(!response.isEmpty, "Matches Decoding success")
        } catch {
            XCTFail("Decoding error: \(error)")
            return
        }
    }
    
    func testPlayerDecoding() throws {
        let url = Bundle.testModule.url(forResource: DomainTestsConstants.playerResponseFileName, withExtension: "json")
        guard let url else {
            XCTFail("Missing file: \(DomainTestsConstants.playerResponseFileName).json")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let response = try JSONDecoder().decode(Player.self, from: data)
            XCTAssert(response.name == "SHOCK")
        } catch {
            XCTFail("Decoding error: \(error)")
            return
        }
    }
}
