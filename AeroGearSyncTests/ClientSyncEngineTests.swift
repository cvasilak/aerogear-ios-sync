import UIKit
import XCTest
import AeroGearSync

class ClientSyncEngineTests: XCTestCase {

    typealias T = String
    var dataStore: InMemoryDataStore<T>!
    var synchonizer: DiffMatchPatchSynchronizer!
    var engine: ClientSyncEngine<DiffMatchPatchSynchronizer, InMemoryDataStore<T>>!

    override func setUp() {
        super.setUp()
        self.dataStore = InMemoryDataStore();
        self.synchonizer = DiffMatchPatchSynchronizer()
        self.engine = ClientSyncEngine(synchronizer: synchonizer, dataStore: dataStore)
    }

    func testInitialize() {
        let clientDoc = ClientDocument<T>(id: "1234", clientId: "client1", content: "testing")
        engine.addDocument(clientDoc)
        let savedDoc = dataStore.getClientDocument("1234", clientId: "client1")!
        XCTAssertEqual("1234" , savedDoc.id)
        XCTAssertEqual("client1", savedDoc.clientId)
        XCTAssertEqual("testing", savedDoc.content)
    }

    func testDiff() {
        let clientDoc = ClientDocument<T>(id: "1234", clientId: "client1", content: "testing")
        engine.addDocument(clientDoc)
        let updatedDoc = ClientDocument<T>(id: "1234", clientId: "client1", content: "testing2")
        let patchMessage = engine.diff(updatedDoc)
        XCTAssertEqual("1234" , patchMessage.documentId)
        XCTAssertEqual("client1" , patchMessage.clientId)
        // TODO: Update this when the patching is synchronizer is implemented.
        XCTAssertTrue(patchMessage.edits.isEmpty)
    }
}

