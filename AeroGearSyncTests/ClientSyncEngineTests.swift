import UIKit
import XCTest
import AeroGearSync

class ClientSyncEngineTests: XCTestCase {

    typealias T = String
    var dataStore: InMemoryDataStore<T>!
    var synchonizer: DiffMatchPatchSynchronizer!
    var engine: ClientSyncEngine<DiffMatchPatchSynchronizer, InMemoryDataStore<T>>!
    var util: DocUtil!

    override func setUp() {
        super.setUp()
        self.dataStore = InMemoryDataStore();
        self.synchonizer = DiffMatchPatchSynchronizer()
        self.engine = ClientSyncEngine(synchronizer: synchonizer, dataStore: dataStore)
        util = DocUtil()
    }

    func testInitialize() {
        engine.addDocument(util.document("testing"))
        let savedDoc = dataStore.getClientDocument(util.documentId, clientId: util.clientId)!
        XCTAssertEqual(util.documentId , savedDoc.id)
        XCTAssertEqual(util.clientId, savedDoc.clientId)
        XCTAssertEqual("testing", savedDoc.content)
    }

    func testDiff() {
        engine.addDocument(util.document("testing"))
        let patchMessage = engine.diff(util.document("testing2"))
        XCTAssertNotNil(patchMessage)
        XCTAssertEqual("1234" , patchMessage!.documentId)
        XCTAssertEqual("client1" , patchMessage!.clientId)
        XCTAssertFalse(patchMessage!.edits.isEmpty)
        XCTAssertEqual(1, patchMessage!.edits.count)
        let diffs:Array<Edit.Diff> = patchMessage!.edits[0].diffs
        XCTAssertEqual(Edit.Operation.Unchanged, diffs[0].operation)
        XCTAssertEqual("testing", diffs[0].text)
        XCTAssertEqual(Edit.Operation.Add, diffs[1].operation)
        XCTAssertEqual("2", diffs[1].text)
    }

    func testPatch() {
        let doc = util.document("Do or do not, there is no try.")
        engine.addDocument(doc)
        var diffs = Array<Edit.Diff>()
        diffs.append(Edit.Diff(operation: Edit.Operation.Unchanged, text: "Do or do not, there is no try"))
        diffs.append(Edit.Diff(operation: Edit.Operation.Delete, text: "."))
        diffs.append(Edit.Diff(operation: Edit.Operation.Add, text: "!"))
        let edit = Edit(clientId: doc.clientId, documentId: doc.id, clientVersion: 0, serverVersion: 0, checksum: "", diffs: diffs)
        engine.patch(PatchMessage(id: doc.id, clientId: doc.clientId, edits: [edit]))
        let patched = dataStore.getClientDocument(util.documentId, clientId: util.clientId)!
        XCTAssertEqual("Do or do not, there is no try!", patched.content)
    }
}

