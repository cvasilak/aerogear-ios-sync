import UIKit
import XCTest
import AeroGearSync

class JsonPatchSynchronizerTests: XCTestCase {
    
    var clientSynchronizer: JsonPatchSynchronizer!
    var util: DocUtil!
    
    override func setUp() {
        super.setUp()
        self.clientSynchronizer = JsonPatchSynchronizer()
        self.util = DocUtil()
    }
 
    func testClientDiffAddPatch() {
        var doc1:AnyObject = ["key1": "value1"]
        var doc2:AnyObject = ["key1": "value1", "key2": "value2"]
        let updated = util.document(doc1)
        let shadowDoc = util.shadow(doc2)
        let edit = clientSynchronizer.clientDiff(updated, shadow: shadowDoc)
        XCTAssertEqual(util.clientId, edit.clientId);
        XCTAssertEqual(util.documentId, edit.documentId);
        XCTAssertEqual(1, edit.diffs.count)
        XCTAssertEqual(JsonPatchDiff.Operation.Add, edit.diffs[0].operation)
        let value: AnyObject = edit.diffs[0].value!
        XCTAssertEqual("value2", value as String)
    }
    
    func testClientDiffRemove() {
        var doc1:AnyObject = ["key1": "value1", "key2": "value2"]
        var doc2:AnyObject = ["key1": "value1"]
        let updated = util.document(doc1)
        let shadowDoc = util.shadow(doc2)
        let edit = clientSynchronizer.clientDiff(updated, shadow: shadowDoc)
        XCTAssertEqual(util.clientId, edit.clientId);
        XCTAssertEqual(util.documentId, edit.documentId);
        XCTAssertEqual(1, edit.diffs.count)
        XCTAssertEqual(JsonPatchDiff.Operation.Remove, edit.diffs[0].operation)
        XCTAssertEqual("/key2", edit.diffs[0].path)
        XCTAssertNil(edit.diffs[0].value)
    }
    
    func testClientDiffReplace() {
        var doc1:AnyObject = ["key1": "value1", "key2": ["key2.1": "value2.1"], "key3": "value3"]
        var doc2:AnyObject = ["key1": "value1", "key2": "value3", "key3": ["key2.1": "value2.1"]]
        let updated = util.document(doc1)
        let shadowDoc = util.shadow(doc2)
        let edit = clientSynchronizer.clientDiff(updated, shadow: shadowDoc)
        XCTAssertEqual(util.clientId, edit.clientId);
        XCTAssertEqual(util.documentId, edit.documentId);
        XCTAssertEqual(2, edit.diffs.count)
        XCTAssertEqual(JsonPatchDiff.Operation.Replace, edit.diffs[0].operation)
        XCTAssertEqual("/key3", edit.diffs[0].path)
        let val: JsonNode = edit.diffs[0].value! as JsonNode
        println("\(val)")
        XCTAssertTrue(val as NSObject == ["key2.1": "value2.1"])
    }
    
    // TODO test Move, Test, Copy
    
    func testClientDiffRemoveAdd() {
        var doc1:AnyObject = ["key1": "value1", "key2": ["key2.1": "value2.1"], "key3": "value3"]
        var doc2:AnyObject = ["key1": "value1", "key2": ["key2.1": "value2.1", "key3": "value3"]]
        let updated = util.document(doc1)
        let shadowDoc = util.shadow(doc2)
        let edit = clientSynchronizer.clientDiff(updated, shadow: shadowDoc)
        XCTAssertEqual(util.clientId, edit.clientId);
        XCTAssertEqual(util.documentId, edit.documentId);
        XCTAssertEqual(2, edit.diffs.count)
        XCTAssertEqual(JsonPatchDiff.Operation.Remove, edit.diffs[0].operation)
        XCTAssertEqual("/key3", edit.diffs[0].path)
        XCTAssertNil(edit.diffs[0].value)
        XCTAssertEqual(JsonPatchDiff.Operation.Add, edit.diffs[1].operation)
        XCTAssertEqual("/key2/key3", edit.diffs[1].path)
        let val: JsonNode = edit.diffs[1].value! as JsonNode
        println("\(val)")
        XCTAssertTrue(val as NSObject == "value3")
    }
    
    func testServerDiff() {
        var doc1:AnyObject = ["key1": "value1"]
        var doc2:AnyObject = ["key1": "value1", "key2": "value2"]
        let shadowDoc = util.shadow(doc1)
        let serverDoc = util.document(doc2)
        let edit = clientSynchronizer.serverDiff(serverDoc, shadow: shadowDoc)
        XCTAssertEqual(util.clientId, edit.clientId);
        XCTAssertEqual(util.documentId, edit.documentId);
        XCTAssertEqual(1, edit.diffs.count)
        XCTAssertEqual(JsonPatchDiff.Operation.Add, edit.diffs[0].operation)
        XCTAssertEqual("/key2", edit.diffs[0].path)
        let value: AnyObject = edit.diffs[0].value!
        XCTAssertEqual("value2", value as String)
    }
    
//    func testPatchShadow() {
//        var doc1:AnyObject = ["key1": "value1"]
//        let shadowDoc = util.shadow(doc1)
//        var diffs = Array<JsonPatchDiff>()
//        diffs.append(JsonPatchDiff(operation: JsonPatchDiff.Operation.Add, path:"/key2", value: ["key2.1": "key2.2"]))
//        let edit = JsonPatchEdit(clientId: util.clientId, documentId: util.documentId, clientVersion: 0, serverVersion: 1, checksum: "", diffs: diffs)
//        let patchedDoc = clientSynchronizer.patchShadow(edit, shadow: shadowDoc)
//        XCTAssertEqual("client1", patchedDoc.clientDocument.clientId)
//        XCTAssertEqual("1234", patchedDoc.clientDocument.id)
//        println("::\(patchedDoc.clientDocument.content)")
//        //XCTAssertEqual("Do or do not, there is no try!", patchedDoc.clientDocument.content)
//    }
//    
    // TODO
    func testPatchDocument() {
        var doc1:AnyObject = ["key1": "value1"]
        let shadowDoc = util.shadow(doc1)
        var diffs = Array<JsonPatchDiff>()
        diffs.append(JsonPatchDiff(operation: JsonPatchDiff.Operation.Add, path: "/key2", value: "value2"))
        // TODO: why do we need Get which is not in spec? get return only key1, do we need to do the get after the first patch get applied???
        diffs.append(JsonPatchDiff(operation: JsonPatchDiff.Operation.Get, path: "", value: nil))
        let edit = JsonPatchEdit(clientId: util.clientId, documentId: util.documentId, clientVersion: 0, serverVersion: 1, checksum: "", diffs: diffs)
        let patchedDoc = clientSynchronizer.patchDocument(edit, clientDocument: shadowDoc.clientDocument)
        XCTAssertEqual(util.clientId, patchedDoc.clientId)
        XCTAssertEqual(util.documentId, patchedDoc.id)
        println("::\(patchedDoc.content)")
        //XCTAssertEqual("Do or do not, there is no try!", patchedDoc.content)
    }
    
}


