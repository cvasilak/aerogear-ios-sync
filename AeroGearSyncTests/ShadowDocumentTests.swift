import XCTest
import AeroGearSync

class ShadowDocumentTests: XCTestCase {

    func testCreateShadowDocumentStringType() {
        var doc = ClientDocument<String>(id: "1234", clientId: "client1", content: "something")
        let shadow = ShadowDocument<String>(clientVersion: 2, serverVersion: 1, clientDocument: doc)
        XCTAssertEqual(1, shadow.serverVersion)
        XCTAssertEqual(2, shadow.clientVersion)
        XCTAssertEqual(doc.content, shadow.clientDocument.content)
    }
    
    func testCreateShadowDocumentIntType() {
        var doc = ClientDocument<Int>(id: "1234", clientId: "client1", content: 99)
        let shadow = ShadowDocument<Int>(clientVersion: 2, serverVersion: 1, clientDocument: doc)
        XCTAssertEqual(1, shadow.serverVersion)
        XCTAssertEqual(2, shadow.clientVersion)
        XCTAssertEqual(doc.content, shadow.clientDocument.content)
    }

}
