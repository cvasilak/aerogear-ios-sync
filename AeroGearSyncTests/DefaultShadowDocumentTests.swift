import UIKit
import XCTest
import AeroGearSync

class DefaultShadowDocumentTests: XCTestCase {

    func testCreateShadowDoc() {
        var doc = DefaultClientDocument<String>(id: "1234", clientId: "client1", content: "something")
        let shadow = DefaultShadowDocument(serverVersion: 1, clientVersion: 2, clientDocument: doc)
        XCTAssertEqual(1, shadow.serverVersion)
        XCTAssertEqual(2, shadow.clientVersion)
        XCTAssertEqual(doc.content, shadow.clientDocument.content)
    }

}
