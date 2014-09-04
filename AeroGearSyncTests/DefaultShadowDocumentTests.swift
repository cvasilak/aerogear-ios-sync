import UIKit
import XCTest
import AeroGearSync

class DefaultShadowDocumentTests: XCTestCase {

    func testExample() {
        let clientDoc = DefaultClientDocument(id: "1234", clientId: "client2", content: "payload")
        let shadow = DefaultShadowDocument(serverVersion: 1, clientVersion: 2, clientDocument: clientDoc)
        XCTAssertEqual(1, shadow.serverVersion)
        XCTAssertEqual(2, shadow.clientVersion)
        //XCTAssertEqualsObject(clientDoc, shadow.clientDocument)
    }

}
