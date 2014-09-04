import UIKit
import XCTest
import AeroGearSync

class InMemoryDataStoreTests: XCTestCase {

    func testCreateDataStore() {
        let dataStore = InMemoryDataStore();
        XCTAssert(true, "Pass")
    }

}
