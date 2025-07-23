import XCTest

@testable import CounterStrikeTVDomain

final class CounterStrikeTVDomainTests: XCTestCase {
    
    // MARK: - CONSTANTS
    
    private enum Constants {
        static let pandaScoreMatchesResponseFile = "PandaScoreMatchesResponse"
    }
    
    // MARK: - LIFE CICLE
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
    
    // MARK: - INTERNAL METHODS
    
    func testMatchesResponseDeserialization() throws {
        let url = Bundle(for: type(of: self)).url(forResource: Constants.pandaScoreMatchesResponseFile, withExtension: "json")
        guard let url else {
            XCTFail("Missing file: \(Constants.pandaScoreMatchesResponseFile).json")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            XCTAssertNoThrow(
                try JSONDecoder().decode([Match].self, from: data),
                "Decoding should succeed for valid JSON"
            )
        } catch {
            XCTFail("Decoding error: \(error)")
            return
        }
    }
}
