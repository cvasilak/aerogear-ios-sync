/*
* JBoss, Home of Professional Open Source.
* Copyright Red Hat, Inc., and individual contributors
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import AeroGearSync
import JSONTools

public typealias JsonNode = [String: AnyObject]

public class JsonPatchSynchronizer: ClientSynchronizer {
    
    public init() {}
    
    public func clientDiff(clientDocument: ClientDocument<JsonNode>, shadow: ShadowDocument<JsonNode>) -> JsonPatchEdit {
        let diffsList:[NSDictionary] = JSONPatch.createPatchesComparingCollectionsOld(clientDocument.content, toNew:shadow.clientDocument.content) as [NSDictionary]
        return edit(shadow.clientDocument, shadow: shadow, diffs: diffsList)
    }

    private func edit(clientDoc: ClientDocument<JsonNode>, shadow: ShadowDocument<JsonNode>, diffs: [NSDictionary]) -> JsonPatchEdit {
        return JsonPatchEdit(clientId: clientDoc.clientId, documentId: clientDoc.id, clientVersion: shadow.clientVersion, serverVersion: shadow.serverVersion, checksum: "", diffs: asAeroGearDiffs(diffs))
    }
    
    private func asAeroGearDiffs(diffs: [NSDictionary]) -> [JsonPatchDiff] {
        return diffs.map {
            let val = $0 as [String: AnyObject]
            let op: String = val["op"] as String
            let value: AnyObject? = val["value"]
            let path: String = val["path"] as String
            return JsonPatchDiff(operation: JsonPatchSynchronizer.asAeroGearOperation(op), path: path, value: value)
        }
    }
    
    private class func asAeroGearOperation(op: String) -> JsonPatchDiff.Operation {
        switch op {
        case "remove":
            return JsonPatchDiff.Operation.Remove
        case "add":
            return JsonPatchDiff.Operation.Add
        case "test":
            return JsonPatchDiff.Operation.Test
        case "move":
            return JsonPatchDiff.Operation.Move
        case "replace":
            return JsonPatchDiff.Operation.Replace
        case "copy":
            return JsonPatchDiff.Operation.Copy
        default:
            return JsonPatchDiff.Operation.Test
        }
    }
    
    public func patchDocument(edit: JsonPatchEdit, clientDocument: ClientDocument<JsonNode>) -> ClientDocument<JsonNode> {
        // we need a mutable copy of the json node
        // https://github.com/grgcombs/JSONTools/blob/master/JSONTools%2FJSONPatch.m#L424
        let collection = clientDocument.content as NSDictionary
        var mutableCollection: NSMutableDictionary = collection.mutableCopy() as NSMutableDictionary
        
        // To get a patched document, we need to add a _get operation at he end of each diff as described in
        // https://github.com/grgcombs/JSONTools/blob/master/JSONTools%2FJSONPatch.h#L26
        // this operation is not part of JSON Patch spec though
        // https://tools.ietf.org/html/rfc6902
        var diffWithGetOperation = edit.diffs
        diffWithGetOperation.append(JsonPatchDiff(operation: JsonPatchDiff.Operation.Get))
        
        let results: AnyObject! = JSONPatch.applyPatches(asJsonPatchDiffs(diffWithGetOperation), toCollection: mutableCollection)
        return ClientDocument<JsonNode>(id: clientDocument.id, clientId: clientDocument.clientId, content: results as JsonNode)
    }
    
    public func patchShadow(edit: JsonPatchEdit, shadow: ShadowDocument<JsonNode>) -> ShadowDocument<JsonNode> {
        return ShadowDocument(clientVersion: edit.clientVersion, serverVersion: shadow.serverVersion, clientDocument: patchDocument(edit, clientDocument: shadow.clientDocument))
    }
    
    public func serverDiff(serverDocument: ClientDocument<JsonNode>, shadow: ShadowDocument<JsonNode>) -> JsonPatchEdit {
        let diffsList:[NSDictionary] = JSONPatch.createPatchesComparingCollectionsOld(shadow.clientDocument.content, toNew:serverDocument.content) as [NSDictionary]
        return edit(shadow.clientDocument, shadow: shadow, diffs: diffsList)
    }

    private func asJsonPatchDiffs(diffs: [JsonPatchDiff]) -> NSArray {
        return diffs.map { ["op": $0.operation.rawValue, "path": $0.path, "value": $0.value ?? ""] }
    }
    
    public func patchMessageFromJson(json: String) -> JsonPatchMessage? {
        return JsonPatchMessage().fromJson(json)
    }
    
    public func createPatchMessage(id: String, clientId: String, edits: [JsonPatchEdit]) -> JsonPatchMessage? {
        return JsonPatchMessage(id: id, clientId: clientId, edits: edits)
    }
    
    public func addContent(clientDocument:ClientDocument<JsonNode>, fieldName:String, inout objectNode:String) {
        objectNode += "\"content\":"
        // convert client document to json
        var jsonErrorOptional: NSError?
        var data = NSJSONSerialization.dataWithJSONObject(clientDocument.content, options:NSJSONWritingOptions(0), error: &jsonErrorOptional)
        objectNode += NSString(data: data!, encoding: NSUTF8StringEncoding)!
    }
}

