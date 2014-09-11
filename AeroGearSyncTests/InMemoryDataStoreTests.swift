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

    func testSaveClientDocument() {
        dataStore.saveClientDocument(defaultClientDoc())
        let clientDocument = dataStore.getClientDocument(documentId, clientId: clientId)!
        assertDefaultClientDocument(clientDocument)
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
        assertDefaultClientDocument(shadow.clientDocument)
    }

    func assertDefaultClientDocument(clientDocument: ClientDocument<String>) {
        XCTAssertEqual(documentId , clientDocument.id)
        XCTAssertEqual(clientId, clientDocument.clientId)
        XCTAssertEqual(content, clientDocument.content)
    }

    func defaultClientDoc() -> ClientDocument<String> {
        return ClientDocument<String>(id: documentId, clientId: clientId, content: content)
    }

    func defaultShadowDoc() -> ShadowDocument<String> {
        return ShadowDocument<String>(clientVersion: 2, serverVersion: 1, clientDocument: defaultClientDoc())
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
