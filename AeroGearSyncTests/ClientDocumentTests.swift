import UIKit
import XCTest
import AeroGearSync

class ClientDocumentTests: XCTestCase {

    func testCreateClientStringDocumentString() {
        let doc = ClientDocument<String>(id: "1234", clientId: "client1", content: "Fletch")
        XCTAssertEqual("client1", doc.clientId)
        XCTAssertEqual("1234", doc.id)
        XCTAssertEqual("Fletch", doc.content)
    }
    
    func testCreateClientIntDocumentString() {
        let doc = ClientDocument<Int>(id: "1234", clientId: "client1", content: 777)
        XCTAssertEqual("client1", doc.clientId)
        XCTAssertEqual("1234", doc.id)
        XCTAssertEqual(777, doc.content)
    }

}
