import UIKit
import XCTest
import AeroGearSync

class DiffMatchPatchSynchronizerTests: XCTestCase {
    
    var clientSynchronizer: DiffMatchPatchSynchronizer!

    override func setUp() {
        super.setUp()
        self.clientSynchronizer = DiffMatchPatchSynchronizer()
    }

    func testServerDiff() {
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

    func testClientDiff() {
        let updated = ClientDocument<String>(id: "1234", clientId: "client1", content: "Do or do not, there is no try.")
        let clientDoc = ClientDocument<String>(id: "1234", clientId: "client1", content: "Do or do not, there is no try!")
        let shadowDoc = ShadowDocument<String>(clientVersion: 2, serverVersion: 1, clientDocument: clientDoc)
        let edit = clientSynchronizer.clientDiff(updated, shadow: shadowDoc)
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

    func testPatchShadow() {
        let clientDoc = ClientDocument<String>(id: "1234", clientId: "client1", content: "Do or do not, there is no try.")
        let shadowDoc = ShadowDocument<String>(clientVersion: 0, serverVersion: 0, clientDocument: clientDoc)
        var diffs = Array<Edit.Diff>()
        diffs.append(Edit.Diff(operation: Edit.Operation.Unchanged, text: "Do or do not, there is not try"))
        diffs.append(Edit.Diff(operation: Edit.Operation.Delete, text: "."))
        diffs.append(Edit.Diff(operation: Edit.Operation.Add, text: "!"))
        let edit = Edit(clientId: "client1", documentId: "1234", clientVersion: 0, serverVersion: 1, checksum: "", diffs: diffs)
        let patchedDoc = clientSynchronizer.patchShadow(edit, shadow: shadowDoc)
        XCTAssertEqual("client1", patchedDoc.clientDocument.clientId)
        XCTAssertEqual("1234", patchedDoc.clientDocument.id)
        XCTAssertEqual("Do or do not, there is no try!", patchedDoc.clientDocument.content)
    }

    func testPatchDocument() {
        let clientDoc = ClientDocument<String>(id: "1234", clientId: "client1", content: "Do or do not, there is no try.")
        let shadowDoc = ShadowDocument<String>(clientVersion: 0, serverVersion: 0, clientDocument: clientDoc)
        var diffs = Array<Edit.Diff>()
        diffs.append(Edit.Diff(operation: Edit.Operation.Unchanged, text: "Do or do not, there is not try"))
        diffs.append(Edit.Diff(operation: Edit.Operation.Delete, text: "."))
        diffs.append(Edit.Diff(operation: Edit.Operation.Add, text: "!"))
        let edit = Edit(clientId: "client1", documentId: "1234", clientVersion: 0, serverVersion: 1, checksum: "", diffs: diffs)
        let patchedDoc = clientSynchronizer.patchDocument(edit, clientDocument: clientDoc)
        XCTAssertEqual("client1", patchedDoc.clientId)
        XCTAssertEqual("1234", patchedDoc.id)
        XCTAssertEqual("Do or do not, there is no try!", patchedDoc.content)
    }
    
}


