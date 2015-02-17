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

public struct DiffMatchPatchEdit: Edit {
    public let clientId: String
    public let documentId: String
    public let clientVersion: Int
    public let serverVersion: Int
    public let checksum: String
    public let diffs: [DiffMatchPatchDiff]
    
    public init(clientId: String, documentId: String, clientVersion: Int, serverVersion: Int, checksum: String, diffs: [DiffMatchPatchDiff]) {
        self.clientId = clientId
        self.documentId = documentId
        self.clientVersion = clientVersion
        self.serverVersion = serverVersion
        self.checksum = checksum
        self.diffs = diffs
    }
    
    public var description: String {
        return "DiffMatchPatchEdit[clientId=\(clientId), documentId=\(documentId), clientVersion=\(clientVersion), serverVersion=\(serverVersion), checksum=\(checksum), diffs=\(diffs)]"
    }
}

public func ==(lhs: DiffMatchPatchEdit, rhs: DiffMatchPatchEdit) -> Bool {
    return lhs.clientId == rhs.clientId &&
        lhs.documentId == rhs.documentId &&
        lhs.serverVersion == rhs.serverVersion &&
        lhs.checksum == rhs.checksum &&
        lhs.diffs.count == rhs.diffs.count
}

