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

public struct JsonPatchDiff: Difference {
    
    public let operation: Operation
    public let path: String
    public let value: AnyObject?
    
    public enum Operation : String, Printable {
        case Add = "add"
        case Copy = "copy"
        case Remove = "remove"
        case Move = "move"
        case Replace = "replace"
        case Test = "test"
        // not in spec! it seems to be a hack in JSONTools to get back patched document
        case Get = "_get"
        public var description : String {
            return self.rawValue
        }
    }
    
    public init(operation: Operation, path: String, value: AnyObject?) {
        self.operation = operation
        self.path = path
        self.value = value
    }
    
    public init(operation: Operation) {
        self.operation = operation
        self.path = ""
        self.value = nil
    }
    
    public var description: String {
        return "JsonPatchDiff[operation=\(operation), path=\(path) value=\(value)]"
    }
}