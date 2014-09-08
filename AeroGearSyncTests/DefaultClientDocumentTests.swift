import UIKit
import XCTest
import AeroGearSync

class DefaultClientDocumentTests: XCTestCase {

    func testCreateClientStringDocument() {
        var doc = DefaultClientDocument<String>(id: "1234", clientId: "client1", content: "something")
        XCTAssertEqual("1234", doc.id)
        XCTAssertEqual("client1", doc.clientId)
        XCTAssertEqual("something", doc.content)
    }

    func testCreateClientIntDocument() {
        var doc = DefaultClientDocument<Int>(id: "1234", clientId: "client1", content: 123)
        XCTAssertEqual("1234", doc.id)
        XCTAssertEqual("client1", doc.clientId)
        XCTAssertEqual(123, doc.content)
    }

}
