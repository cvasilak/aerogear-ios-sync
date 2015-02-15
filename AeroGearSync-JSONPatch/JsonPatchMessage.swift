//
//  JsonPatchMessage.swift
//  AeroGearSyncClient
//
//  Created by Christos Vasilakis on 2/12/15.
//  Copyright (c) 2015 aerogear. All rights reserved.
//

import Foundation
import AeroGearSync

public class JsonPatchMessage<E>:PatchMessage<JsonPatchEdit>, Printable {
    
    public override init() {
        super.init()
    }
    
    public override init(id: String, clientId: String, edits: [JsonPatchEdit]) {
        super.init(id: id, clientId: clientId, edits: edits)
    }
    
    override public func asJson() -> String {
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
    
        println("-----------------patch-message-----------------")
        println(str)
        return str
    }
    
    override public func fromJson(var json:String) -> PatchMessage<JsonPatchEdit>? {
        if let dict = asDictionary(json) {
            println(dict)
            
            let id = dict["id"] as String
            let clientId = dict["clientId"] as String
            var edits = Array<JsonPatchEdit>()
            
            if let e = dict["edits"] as? [String: AnyObject] {
                for (key: String, jsonEdit) in e {
                    var diffs = Array<JsonPatchDiff>()
                    for (key: String, jsonDiff) in jsonEdit["diffs"] as [String: AnyObject] {
                        diffs.append(JsonPatchDiff(operation: JsonPatchDiff.Operation(rawValue: jsonDiff["operation"] as String)!,
                            path: jsonDiff["path"] as String, value: jsonDiff["value"] as String))
                    }
                    edits.append(JsonPatchEdit(clientId: clientId,
                        documentId: id,
                        clientVersion: jsonEdit["clientVersion"] as Int,
                        serverVersion: jsonEdit["serverVersion"] as Int,
                        checksum: jsonEdit["checksum"] as String,
                        diffs: diffs))
                }
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