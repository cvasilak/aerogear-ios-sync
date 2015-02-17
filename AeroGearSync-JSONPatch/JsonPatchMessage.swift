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

import Foundation
import AeroGearSync

public struct JsonPatchMessage: PatchMessage, Printable {
    public let documentId: String!
    public let clientId: String!
    public let edits: [JsonPatchEdit]!
    
    public var description: String {
        return "JsonPatchMessage[documentId=\(documentId), clientId=\(clientId), edits=\(edits)]"
    }
    
    public init() {}
    
    public init(id: String, clientId: String, edits: [JsonPatchEdit]) {
        self.documentId = id
        self.clientId = clientId
        self.edits = edits
    }
    
    public func asJson() -> String {
        var str = "{\"msgType\":\"patch\",\"id\":\"" + documentId + "\",\"clientId\":\"" + clientId + "\""
        str += ",\"edits\":["
        let count = edits.count-1
        for i in 0...count {
            let edit = edits[i]
            str += "{\"clientVersion\":\(edit.clientVersion)"
            str += ",\"serverVersion\":\(edit.serverVersion)"
            str += ",\"checksum\":\"\(edit.checksum)"
            str += "\",\"diffs\":["
            let diffscount = edit.diffs.count-1
            for y in 0...diffscount {
                str += "{\"op\":\"" + edit.diffs[y].operation.rawValue + "\", \"path\":\"" + edit.diffs[y].path + "\","
                str += "\"value\":"
                var value:AnyObject? = edit.diffs[y].value
                if var val = value as? String { // if string escape accordingly
                    val = val.stringByReplacingOccurrencesOfString("\"", withString: "\\\"", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    str += "\"" + val + "\"}"
                } else {
                    str += "\(value)" + "\"}"
                }
                
                if y != diffscount {
                    str += ","
                }
            }
            
            str += "]}"
            
            if i != count {
                str += ","
            }
        }
            
        str += "]}"
    
        return str
    }
    
    public func fromJson(var json:String) -> JsonPatchMessage? {
        if let dict = asDictionary(json) {
            let id = dict["id"] as String
            let clientId = dict["clientId"] as String
            var edits = [JsonPatchEdit]()
            
            if let e = dict["edits"] as? [[String: AnyObject]] {
                for edit in e {
                    var diffs = [JsonPatchDiff]()
                    if let d = edit["diffs"] as? [[String: AnyObject]] {
                        for diff in d {
                            diffs.append(JsonPatchDiff(operation: JsonPatchDiff.Operation(rawValue: diff["op"] as String)!,
                                path: diff["path"] as String, value: diff["value"] as? String))
                        }
                    }
                    
                    edits.append(JsonPatchEdit(clientId: clientId,
                        documentId: id,
                        clientVersion: edit["clientVersion"] as Int,
                        serverVersion: edit["serverVersion"] as Int,
                        checksum: edit["checksum"] as String,
                        diffs: diffs))
                }
            }
            return JsonPatchMessage(id: id, clientId: clientId, edits: edits)
        }
        return Optional.None
    }
    
    /**
    Tries to convert the passed in String into a Swift Dictionary<String, AnyObject>
    
    :param: jsonString the JSON string to convert into a Dictionary
    :returns: Optional Dictionary<String, AnyObject>
    */
    public func asDictionary(jsonString: String) -> [String: AnyObject]? {
        var jsonErrorOptional: NSError?
        return NSJSONSerialization.JSONObjectWithData((jsonString as NSString).dataUsingEncoding(NSUTF8StringEncoding)!,
            options: NSJSONReadingOptions(0), error: &jsonErrorOptional) as? [String: AnyObject]
    }
    
    /**
    Tries to convert the passed in Dictionary<String, AnyObject> into a JSON String representation.
    
    :param: the Dictionary<String, AnyObject> to try to convert.
    :returns: optionally the JSON string representation for the dictionary.
    */
    public func asJsonString(dict: [String:  AnyObject]) -> String? {
        var jsonErrorOptional: NSError?
        var data = NSJSONSerialization.dataWithJSONObject(dict, options:NSJSONWritingOptions(0), error: &jsonErrorOptional)
        return NSString(data: data!, encoding: NSUTF8StringEncoding)
    }
}