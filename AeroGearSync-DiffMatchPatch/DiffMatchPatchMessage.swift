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

public class DiffMatchPatchMessage<E>:PatchMessage<DiffMatchPatchEdit>, Printable {
    
    public override init() {
        super.init()
    }
    
    public override init(id: String, clientId: String, edits: [DiffMatchPatchEdit]) {
        super.init(id: id, clientId: clientId, edits: edits)
    }
    
    override public func asJson() -> String {
        // TODO: This should be solved on the server side.
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
                let text = edit.diffs[y].text.stringByReplacingOccurrencesOfString("\"", withString: "\\\"", options: NSStringCompareOptions.LiteralSearch, range: nil)
                str += "{\"operation\":\"" + edit.diffs[y].operation.rawValue + "\",\"text\":\"" + text + "\"}"
                if y != diffscount {
                    str += ","
                }
            }
            str += "]}]}"
        }
        return str
    }
    
    override public func fromJson(var json:String) -> PatchMessage<DiffMatchPatchEdit>? {
        if let dict = asDictionary(json) {
            let id = dict["id"] as String
            let clientId = dict["clientId"] as String
            var edits = Array<DiffMatchPatchEdit>()
            for (key: String, jsonEdit) in dict["edits"] as [String: AnyObject] {
                var diffs = Array<DiffMatchPatchDiff>()
                for (key: String, jsonDiff) in jsonEdit["diffs"] as [String: AnyObject] {
                    diffs.append(DiffMatchPatchDiff(operation: DiffMatchPatchDiff.Operation(rawValue: jsonDiff["operation"] as String)!,
                       text: jsonDiff["text"] as String))
                }
                edits.append(DiffMatchPatchEdit(clientId: clientId,
                    documentId: id,
                    clientVersion: jsonEdit["clientVersion"] as Int,
                    serverVersion: jsonEdit["serverVersion"] as Int,
                    checksum: jsonEdit["checksum"] as String,
                    diffs: diffs))
            }
            return PatchMessage(id: id, clientId: clientId, edits: edits)
        }
        return Optional.None
    }
    
    /**
    Tries to convert the passed in String into a Swift Dictionary<String, AnyObject>
    
    :param: jsonString the JSON string to convert into a Dictionary
    :returns: Optional Dictionary<String, AnyObject>
    */
    public func asDictionary(jsonString: String) -> Dictionary<String, AnyObject>? {
        var jsonErrorOptional: NSError?
        return NSJSONSerialization.JSONObjectWithData((jsonString as NSString).dataUsingEncoding(NSUTF8StringEncoding)!,
            options: NSJSONReadingOptions(0), error: &jsonErrorOptional) as? Dictionary<String, AnyObject>
    }
    
    /**
    Tries to convert the passed in Dictionary<String, AnyObject> into a JSON String representation.
    
    :param: the Dictionary<String, AnyObject> to try to convert.
    :returns: optionally the JSON string representation for the dictionary.
    */
    public func asJsonString(dict: Dictionary<String, AnyObject>) -> String? {
        var jsonErrorOptional: NSError?
        var data = NSJSONSerialization.dataWithJSONObject(dict, options:NSJSONWritingOptions(0), error: &jsonErrorOptional)
        return NSString(data: data!, encoding: NSUTF8StringEncoding)
    }
}