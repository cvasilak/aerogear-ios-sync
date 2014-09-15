import UIKit
import XCTest
import AeroGearSync

class DiffMatchPatchSynchronizerTests: XCTestCase {
    
    func testServerDiff() {
        let clientSynchronizer = DiffMatchPatchSynchronizer()
        let clientDoc = ClientDocument<String>(id: "1234", clientId: "client1", content: "Do or do not, there is no try.")
        let shadowDoc = ShadowDocument<String>(clientVersion: 2, serverVersion: 1, clientDocument: clientDoc)
        
        let serverDoc = ClientDocument<String>(id: "1234", clientId: "client1", content: "Do or do not, there is no try!")
        let edit = clientSynchronizer.serverDiff(serverDoc, shadow: shadowDoc)
        XCTAssertEqual("client1", edit.clientId);
        XCTAssertEqual("1234", edit.documentId);
        XCTAssertEqual(3, edit.diffs.count)
        XCTAssertEqual(Edit.Operation.Unchanged, edit.diffs[0].operation)
        XCTAssertEqual("Do or do not, there is no try", edit.diffs[0].text)
        XCTAssertEqual(Edit.Operation.Delete, edit.diffs[1].operation)
        XCTAssertEqual(".", edit.diffs[1].text)
        XCTAssertEqual(Edit.Operation.Add, edit.diffs[2].operation)
        XCTAssertEqual("!", edit.diffs[2].text)
    }
    
}


