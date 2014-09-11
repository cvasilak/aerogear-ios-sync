import UIKit
import XCTest
import AeroGearSync

class InMemoryDataStoreTests: XCTestCase {

    var documentId, clientId, content: String!
    var dataStore: InMemoryDataStore<String>!

    override func setUp() {
        super.setUp()
        self.dataStore = InMemoryDataStore<String>();
        documentId = "1234"
        clientId = "client1"
        content = "something"
    }

    func testSaveShadowDocument() {
        dataStore.saveShadowDocument(defaultShadowDoc())
        let shadow = dataStore.getShadowDocument(documentId, clientId: clientId)!
        assertDefaultShadow(shadow)
    }

    func testSaveBackupShadow() {
        dataStore.saveBackupShadowDocument(defaultBackupShadowDoc())
        let backup = dataStore.getBackupShadowDocument(documentId, clientId: clientId)!
        XCTAssertEqual(1, backup.version)
        assertDefaultShadow(backup.shadowDocument)
    }
    
    func testSaveEdits() {
        let edit1 = defaultEdit(clientVersion: 1, serverVersion: 1)
        dataStore.saveEdits(edit1)
        XCTAssertEqual(1, dataStore.getEdits(documentId, clientId: clientId)!.count)
        let edit2 = defaultEdit(clientVersion: 2, serverVersion: 1)
        dataStore.saveEdits(edit2)
        XCTAssertEqual(2, dataStore.getEdits(documentId, clientId: clientId)!.count)
    }

    func testRemoveEdit() {
        let edit = defaultEdit(clientVersion: 1, serverVersion: 1)
        dataStore.saveEdits(edit)
        dataStore.removeEdit(edit)
        XCTAssertEqual(0, dataStore.getEdits(documentId, clientId: clientId)!.count)
    }

    func testRemoveEdits() {
        dataStore.saveEdits(defaultEdit(clientVersion: 1, serverVersion: 1))
        dataStore.saveEdits(defaultEdit(clientVersion: 2, serverVersion: 1))
        dataStore.saveEdits(defaultEdit(clientVersion: 3, serverVersion: 1))
        dataStore.removeEdits(documentId, clientId: clientId)
        let edits: Optional<[Edit]> = dataStore.getEdits(documentId, clientId: clientId)
        XCTAssertNil(edits)
    }

    func assertDefaultShadow(shadow: ShadowDocument<String>) {
        XCTAssertEqual(2, shadow.clientVersion)
        XCTAssertEqual(1, shadow.serverVersion)
        XCTAssertEqual(documentId , shadow.clientDocument.id)
        XCTAssertEqual(clientId, shadow.clientDocument.clientId)
        XCTAssertEqual(content, shadow.clientDocument.content)
    }

    func defaultShadowDoc() -> ShadowDocument<String> {
        let doc = ClientDocument<String>(id: documentId, clientId: clientId, content: content)
        return ShadowDocument<String>(clientVersion: 2, serverVersion: 1, clientDocument: doc)
    }

    func defaultBackupShadowDoc() -> BackupShadowDocument<String> {
        return BackupShadowDocument<String>(version: 1, shadowDocument: defaultShadowDoc())
    }

    func defaultEdit(# clientVersion: UInt64, serverVersion: UInt64) -> Edit {
        return Edit(clientId: clientId,
            documentId: documentId,
            clientVersion: clientVersion,
            serverVersion: serverVersion,
            checksum: "",
            diffs: [Diff]())
    }
}
