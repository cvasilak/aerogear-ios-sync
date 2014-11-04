import UIKit
import XCTest
import AeroGearSync

class ClientSyncEngineTests: XCTestCase {

    typealias T = String
    var dataStore: InMemoryDataStore<T>!
    var synchonizer: DiffMatchPatchSynchronizer!
    var engine: ClientSyncEngine<DiffMatchPatchSynchronizer, InMemoryDataStore<T>>!
    var util: DocUtil!
    var emptyCallback: ((ClientDocument<T>) -> ())!

    override func setUp() {
        super.setUp()
        self.dataStore = InMemoryDataStore()
        self.synchonizer = DiffMatchPatchSynchronizer()
        self.engine = ClientSyncEngine(synchronizer: synchonizer, dataStore: dataStore)
        self.util = DocUtil()
        self.emptyCallback = { (doc:ClientDocument<T>) -> () in }
    }

    func testInitialize() {
        engine.addDocument(util.document("testing"), callback: emptyCallback)
        let savedDoc = dataStore.getClientDocument(util.documentId, clientId: util.clientId)!
        XCTAssertEqual(util.documentId , savedDoc.id)
        XCTAssertEqual(util.clientId, savedDoc.clientId)
        XCTAssertEqual("testing", savedDoc.content)
    }

    func testDiff() {
        engine.addDocument(util.document("testing"), callback: emptyCallback)
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
        engine.addDocument(doc, callback: { (doc:ClientDocument<T>) -> () in
            XCTAssertEqual("Do or do not, there is no try!", doc.content)
        })
        var diffs = [Edit.Diff(operation: Edit.Operation.Unchanged, text: "Do or do not, there is no try"),
            Edit.Diff(operation: Edit.Operation.Delete, text: "."),
            Edit.Diff(operation: Edit.Operation.Add, text: "!")]
        let edit = Edit(clientId: doc.clientId, documentId: doc.id, clientVersion: 0, serverVersion: 0, checksum: "", diffs: diffs)
        engine.patch(PatchMessage(id: doc.id, clientId: doc.clientId, edits: [edit]))
    }

    func testPatchMultipleEdits() {
        let doc = util.document("Do or do not, there is no try.")
        engine.addDocument(doc, callback: { (doc:ClientDocument<T>) -> () in
            XCTAssertEqual("Do or do not, there is no try?", doc.content)
        })
        let edit1 = Edit(clientId: doc.clientId, documentId: doc.id, clientVersion: 0, serverVersion: 0, checksum: "",
            diffs: [Edit.Diff(operation: Edit.Operation.Unchanged, text: "Do or do not, there is no try"),
                Edit.Diff(operation: Edit.Operation.Delete, text: "."),
                Edit.Diff(operation: Edit.Operation.Add, text: "!")])
        let edit2 = Edit(clientId: doc.clientId, documentId: doc.id, clientVersion: 0, serverVersion: 1, checksum: "",
            diffs: [Edit.Diff(operation: Edit.Operation.Unchanged, text: "Do or do not, there is no try"),
                Edit.Diff(operation: Edit.Operation.Delete, text: "!"),
                Edit.Diff(operation: Edit.Operation.Add, text: "?")])
        engine.patch(PatchMessage(id: doc.id, clientId: doc.clientId, edits: [edit1, edit2]))
    }

    func testPatchTwoDocuments() {
        let doc1 = ClientDocument<String>(id: "1234", clientId: "client1", content: "Doc1")

        engine.addDocument(doc1, callback: { (doc:ClientDocument<T>) -> () in
            XCTAssertEqual("Document1", doc.content)
        })
        let doc2 = ClientDocument<String>(id: "5678", clientId: "client2", content: "Doc2")
        engine.addDocument(doc2, callback: { (doc:ClientDocument<T>) -> () in
            XCTAssertEqual("Document2", doc.content)
        })
        var diffs1 = Array<Edit.Diff>()
        diffs1.append(Edit.Diff(operation: Edit.Operation.Unchanged, text: "Doc"))
        diffs1.append(Edit.Diff(operation: Edit.Operation.Add, text: "ument"))
        diffs1.append(Edit.Diff(operation: Edit.Operation.Unchanged, text: "1"))
        let edit1 = Edit(clientId: doc1.clientId, documentId: doc1.id, clientVersion: 0, serverVersion: 0, checksum: "", diffs: diffs1)

        var diffs2 = Array<Edit.Diff>()
        diffs2.append(Edit.Diff(operation: Edit.Operation.Unchanged, text: "Doc"))
        diffs2.append(Edit.Diff(operation: Edit.Operation.Add, text: "ument"))
        diffs2.append(Edit.Diff(operation: Edit.Operation.Unchanged, text: "2"))
        let edit2 = Edit(clientId: doc2.clientId, documentId: doc2.id, clientVersion: 0, serverVersion: 0, checksum: "", diffs: diffs2)

        engine.patch(PatchMessage(id: doc1.id, clientId: doc1.clientId, edits: [edit1]))
        engine.patch(PatchMessage(id: doc2.id, clientId: doc2.clientId, edits: [edit2]))
    }
}

