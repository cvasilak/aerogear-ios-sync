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

public struct DiffMatchPatchDiff: Difference {
    
    public let operation: Operation
    public let text: String
    
    public enum Operation : String, Printable {
        case Add = "ADD"
        case Delete = "DELETE"
        case Unchanged = "UNCHANGED"
        public var description : String {
            return self.rawValue
        }
    }
    
    public init(operation: Operation, text: String) {
        self.operation = operation
        self.text = text
    }
    
    public var description: String {
        return "DiffMatchPatchDiff[operation=\(operation), text=\(text)]"
    }
}