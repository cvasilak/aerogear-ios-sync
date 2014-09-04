import UIKit
import XCTest
import AeroGearSync

class DefaultClientDocumentTests: XCTestCase {

    func testCreateClientDocument() {
        let doc = DefaultClientDocument(id: "1234", clientId: "client1", content: "something")
        XCTAssertEqual("1234", doc.id)
        XCTAssertEqual("client1", doc.clientId)
        XCTAssertEqual("something", doc.content)
    }

}
