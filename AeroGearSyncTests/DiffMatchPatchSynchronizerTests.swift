import UIKit
import XCTest
import AeroGearSync

class DiffMatchPatchSynchronizerTests: XCTestCase {
    
    func testServerDiff() {
        let clientSynchronizer = DiffMatchPatchSynchronizer()
        let clientDoc = ClientDocument<String>(id: "1234", clientId: "client1", content: "Do or do not, there is no try.")
        let shadowDoc = ShadowDocument<String>(clientVersion: 2, serverVersion: 1, clientDocument: clientDoc)
        
        let serverDoc = ClientDocument<String>(id: "1234", clientId: "client1", content: "Do or do not, there is no try!")
        clientSynchronizer.serverDiff(serverDoc, shadowDocument: shadowDoc)
    }
    
}


