import UIKit
import XCTest
import AeroGearSync

class InMemoryDataStoreTests: XCTestCase {

    var documentId, clientId, content: String!
    var dataStore: InMemoryDataStore<String>!
    var util: DocUtil!

    override func setUp() {
        super.setUp()
        dataStore = InMemoryDataStore<String>();
        util = DocUtil();
    }

    func testSaveClientDocument() {
        dataStore.saveClientDocument(util.document())
        let clientDocument = dataStore.getClientDocument(util.documentId, clientId: util.clientId)!
        assertDefaultClientDocument(clientDocument)
    }

    func testSaveShadowDocument() {
        dataStore.saveShadowDocument(util.shadow())
        let shadow = dataStore.getShadowDocument(util.documentId, clientId: util.clientId)!
        assertDefaultShadow(shadow)
    }

    func testSaveBackupShadow() {
        dataStore.saveBackupShadowDocument(util.backupShadow())
        let backup = dataStore.getBackupShadowDocument(util.documentId, clientId: util.clientId)!
        XCTAssertEqual(1, backup.version)
        assertDefaultShadow(backup.shadowDocument)
    }
    
    func testSaveEdits() {
        let edit1 = defaultEdit(clientVersion: 1, serverVersion: 1)
        dataStore.saveEdits(edit1)
        XCTAssertEqual(1, dataStore.getEdits(util.documentId, clientId: util.clientId)!.count)
        let edit2 = defaultEdit(clientVersion: 2, serverVersion: 1)
        dataStore.saveEdits(edit2)
        XCTAssertEqual(2, dataStore.getEdits(util.documentId, clientId: util.clientId)!.count)
    }

    func testRemoveEdit() {
        let edit = defaultEdit(clientVersion: 1, serverVersion: 1)
        dataStore.saveEdits(edit)
        dataStore.removeEdit(edit)
        XCTAssertEqual(0, dataStore.getEdits(util.documentId, clientId: util.clientId)!.count)
    }

    func testRemoveEdits() {
        dataStore.saveEdits(defaultEdit(clientVersion: 1, serverVersion: 1))
        dataStore.saveEdits(defaultEdit(clientVersion: 2, serverVersion: 1))
        dataStore.saveEdits(defaultEdit(clientVersion: 3, serverVersion: 1))
        dataStore.removeEdits(util.documentId, clientId: util.clientId)
        let edits: Optional<[Edit]> = dataStore.getEdits(util.documentId, clientId: util.clientId)
        XCTAssertNil(edits)
    }

    func assertDefaultShadow(shadow: ShadowDocument<String>) {
        XCTAssertEqual(0, shadow.clientVersion)
        XCTAssertEqual(0, shadow.serverVersion)
        assertDefaultClientDocument(shadow.clientDocument)
    }

    func assertDefaultClientDocument(clientDocument: ClientDocument<String>) {
        XCTAssertEqual(util.documentId , clientDocument.id)
        XCTAssertEqual(util.clientId, clientDocument.clientId)
        XCTAssertEqual(util.content, clientDocument.content)
    }

    func defaultEdit(# clientVersion: UInt64, serverVersion: UInt64) -> Edit {
        return Edit(clientId: util.clientId,
            documentId: util.documentId,
            clientVersion: clientVersion,
            serverVersion: serverVersion,
            checksum: "",
            diffs: [])
    }
}
