import UIKit
import XCTest
import AeroGearSync
import AeroGearSyncDiffMatchPatch

class DiffMatchPatchSynchronizerTests: XCTestCase {
    
    var clientSynchronizer: DiffMatchPatchSynchronizer!
    var util: DocUtil!

    override func setUp() {
        super.setUp()
        self.clientSynchronizer = DiffMatchPatchSynchronizer()
        self.util = DocUtil()
    }

    func testServerDiff() {
        let shadowDoc = util.shadow("Do or do not, there is no try.")
        let serverDoc = util.document("Do or do not, there is no try!")
        let edit = clientSynchronizer.serverDiff(serverDoc, shadow: shadowDoc)
        XCTAssertEqual(util.clientId, edit.clientId);
        XCTAssertEqual(util.documentId, edit.documentId);
        XCTAssertEqual(3, edit.diffs.count)
        XCTAssertEqual(DiffMatchPatchDiff.Operation.Unchanged, edit.diffs[0].operation)
        XCTAssertEqual("Do or do not, there is no try", edit.diffs[0].text)
        XCTAssertEqual(DiffMatchPatchDiff.Operation.Delete, edit.diffs[1].operation)
        XCTAssertEqual(".", edit.diffs[1].text)
        XCTAssertEqual(DiffMatchPatchDiff.Operation.Add, edit.diffs[2].operation)
        XCTAssertEqual("!", edit.diffs[2].text)
    }

    func testClientDiff() {
        let updated = util.document("Do or do not, there is no try.")
        let shadowDoc = util.shadow("Do or do not, there is no try!")
        let edit = clientSynchronizer.clientDiff(updated, shadow: shadowDoc)
        XCTAssertEqual(util.clientId, edit.clientId);
        XCTAssertEqual(util.documentId, edit.documentId);
        XCTAssertEqual(3, edit.diffs.count)
        XCTAssertEqual(DiffMatchPatchDiff.Operation.Unchanged, edit.diffs[0].operation)
        XCTAssertEqual("Do or do not, there is no try", edit.diffs[0].text)
        XCTAssertEqual(DiffMatchPatchDiff.Operation.Delete, edit.diffs[1].operation)
        XCTAssertEqual(".", edit.diffs[1].text)
        XCTAssertEqual(DiffMatchPatchDiff.Operation.Add, edit.diffs[2].operation)
        XCTAssertEqual("!", edit.diffs[2].text)
    }

    func testPatchShadow() {
        let shadowDoc = util.shadow("Do or do not, there is no try.")
        var diffs = Array<DiffMatchPatchDiff>()
        diffs.append(DiffMatchPatchDiff(operation: DiffMatchPatchDiff.Operation.Unchanged, text: "Do or do not, there is not try"))
        diffs.append(DiffMatchPatchDiff(operation: DiffMatchPatchDiff.Operation.Delete, text: "."))
        diffs.append(DiffMatchPatchDiff(operation: DiffMatchPatchDiff.Operation.Add, text: "!"))
        let edit = DiffMatchPatchEdit(clientId: util.clientId, documentId: util.documentId, clientVersion: 0, serverVersion: 1, checksum: "", diffs: diffs)
        let patchedDoc = clientSynchronizer.patchShadow(edit, shadow: shadowDoc)
        XCTAssertEqual("client1", patchedDoc.clientDocument.clientId)
        XCTAssertEqual("1234", patchedDoc.clientDocument.id)
        XCTAssertEqual("Do or do not, there is no try!", patchedDoc.clientDocument.content)
    }

    func testPatchDocument() {
        let shadowDoc = util.shadow("Do or do not, there is no try.")
        var diffs = Array<DiffMatchPatchDiff>()
        diffs.append(DiffMatchPatchDiff(operation: DiffMatchPatchDiff.Operation.Unchanged, text: "Do or do not, there is not try"))
        diffs.append(DiffMatchPatchDiff(operation: DiffMatchPatchDiff.Operation.Delete, text: "."))
        diffs.append(DiffMatchPatchDiff(operation: DiffMatchPatchDiff.Operation.Add, text: "!"))
        let edit = DiffMatchPatchEdit(clientId: util.clientId, documentId: util.documentId, clientVersion: 0, serverVersion: 1, checksum: "", diffs: diffs)
        let patchedDoc = clientSynchronizer.patchDocument(edit, clientDocument: shadowDoc.clientDocument)
        XCTAssertEqual(util.clientId, patchedDoc.clientId)
        XCTAssertEqual(util.documentId, patchedDoc.id)
        XCTAssertEqual("Do or do not, there is no try!", patchedDoc.content)
    }
    
}


