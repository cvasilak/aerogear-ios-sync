import UIKit
import XCTest
import AeroGearSync

class InMemoryDataStoreTests: XCTestCase {

    func testSaveShadowDocument() {
        let documentId = "1234", clientId = "client1", content = "something"
        let dataStore = InMemoryDataStore<String>();
        var doc = ClientDocument<String>(id: documentId, clientId: clientId, content: content)
        let shadow = ShadowDocument(clientVersion: 2, serverVersion: 1, clientDocument: doc)
        dataStore.saveShadowDocument(shadow)
        
        let saved = dataStore.getShadowDocument(documentId, clientId: clientId)!
        XCTAssertEqual(2, saved.clientVersion)
        XCTAssertEqual(1, saved.serverVersion)
        XCTAssertEqual(documentId , saved.clientDocument.id)
        XCTAssertEqual(clientId, saved.clientDocument.clientId)
        XCTAssertEqual(content, saved.clientDocument.content)
    }

}
