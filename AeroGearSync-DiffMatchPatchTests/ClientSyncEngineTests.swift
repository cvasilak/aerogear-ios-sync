import XCTest
import AeroGearSync
import AeroGearSyncDiffMatchPatch

class ClientSyncEngineTests: XCTestCase {

    typealias T = String
    typealias E = DiffMatchPatchEdit

    var dataStore: InMemoryDataStore<T, E>!
    var synchonizer: DiffMatchPatchSynchronizer!
    var engine: ClientSyncEngine<DiffMatchPatchSynchronizer, InMemoryDataStore<T, E>>!
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
        let patchMessage: PatchMessage! = engine.diff(util.document("testing2"))
        XCTAssertTrue(patchMessage != nil)
        XCTAssertEqual("1234" , patchMessage.documentId)
        XCTAssertEqual("client1" , patchMessage.clientId)
        XCTAssertFalse(patchMessage.edits.isEmpty)
        XCTAssertEqual(1, patchMessage.edits.count)
        let diffs:Array<DiffMatchPatchDiff> = patchMessage.edits[0].diffs
        XCTAssertEqual(DiffMatchPatchDiff.Operation.Unchanged, diffs[0].operation)
        XCTAssertEqual("testing", diffs[0].text)
        XCTAssertEqual(DiffMatchPatchDiff.Operation.Add, diffs[1].operation)
        XCTAssertEqual("2", diffs[1].text)
        let shadow = dataStore.getShadowDocument(patchMessage.documentId, clientId: patchMessage.clientId)!
        XCTAssertEqual(1, shadow.clientVersion)
        XCTAssertEqual(0, shadow.serverVersion)
    }

    func testPatch() {
        let doc = util.document("Do or do not, there is no try.")
        engine.addDocument(doc, callback: { (doc:ClientDocument<T>) -> () in
            XCTAssertEqual("Do or do not, there is no try!", doc.content)
        })
        var diffs = [DiffMatchPatchDiff(operation: .Unchanged, text: "Do or do not, there is no try"),
            DiffMatchPatchDiff(operation: .Delete, text: "."),
            DiffMatchPatchDiff(operation: .Add, text: "!")]
        let edit = DiffMatchPatchEdit(clientId: doc.clientId, documentId: doc.id, clientVersion: 0, serverVersion: 0, checksum: "", diffs: diffs)
        engine.patch(PatchMessage(id: doc.id, clientId: doc.clientId, edits: [edit]))
    }

    func testPatchMultipleEdits() {
        let doc = util.document("Do or do not, there is no try.")
        engine.addDocument(doc, callback: { (doc:ClientDocument<T>) -> () in
            XCTAssertEqual("Do or do not, there is no try?", doc.content)
        })
        let edit1 = DiffMatchPatchEdit(clientId: doc.clientId, documentId: doc.id, clientVersion: 0, serverVersion: 0, checksum: "",
            diffs: [DiffMatchPatchDiff(operation: .Unchanged, text: "Do or do not, there is no try"),
                DiffMatchPatchDiff(operation: .Delete, text: "."),
                DiffMatchPatchDiff(operation: .Add, text: "!")])
        let edit2 = DiffMatchPatchEdit(clientId: doc.clientId, documentId: doc.id, clientVersion: 0, serverVersion: 1, checksum: "",
            diffs: [DiffMatchPatchDiff(operation: .Unchanged, text: "Do or do not, there is no try"),
                DiffMatchPatchDiff(operation: .Delete, text: "!"),
                DiffMatchPatchDiff(operation: .Add, text: "?")])
        engine.patch(PatchMessage(id: doc.id, clientId: doc.clientId, edits: [edit1, edit2]))
        XCTAssertTrue(dataStore.getEdits(doc.id, clientId: doc.clientId) == nil)
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
        var diffs1 = Array<DiffMatchPatchDiff>()
        diffs1.append(DiffMatchPatchDiff(operation: .Unchanged, text: "Doc"))
        diffs1.append(DiffMatchPatchDiff(operation: .Add, text: "ument"))
        diffs1.append(DiffMatchPatchDiff(operation: .Unchanged, text: "1"))
        let edit1 = DiffMatchPatchEdit(clientId: doc1.clientId, documentId: doc1.id, clientVersion: 0, serverVersion: 0, checksum: "", diffs: diffs1)

        var diffs2 = Array<DiffMatchPatchDiff>()
        diffs2.append(DiffMatchPatchDiff(operation: .Unchanged, text: "Doc"))
        diffs2.append(DiffMatchPatchDiff(operation: .Add, text: "ument"))
        diffs2.append(DiffMatchPatchDiff(operation: .Unchanged, text: "2"))
        let edit2 = DiffMatchPatchEdit(clientId: doc2.clientId, documentId: doc2.id, clientVersion: 0, serverVersion: 0, checksum: "", diffs: diffs2)

        engine.patch(PatchMessage(id: doc1.id, clientId: doc1.clientId, edits: [edit1]))
        engine.patch(PatchMessage(id: doc2.id, clientId: doc2.clientId, edits: [edit2]))
        XCTAssertTrue(dataStore.getEdits(doc1.id, clientId: doc1.clientId) == nil)
        XCTAssertTrue(dataStore.getEdits(doc2.id, clientId: doc2.clientId) == nil)
    }
}