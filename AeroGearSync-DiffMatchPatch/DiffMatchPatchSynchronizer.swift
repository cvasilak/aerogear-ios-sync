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

public class DiffMatchPatchSynchronizer: ClientSynchronizer {

    let dmp: DiffMatchPatch

    public init() {
        self.dmp = DiffMatchPatch()
    }

    public func clientDiff(clientDocument: ClientDocument<String>, shadow: ShadowDocument<String>) -> DiffMatchPatchEdit {
        let diffs = dmp.diff_mainOfOldString(clientDocument.content, andNewString: shadow.clientDocument.content).copy() as [Diff]
        return edit(shadow.clientDocument, shadow: shadow, diffs: diffs)
    }

    public func patchDocument(edit: DiffMatchPatchEdit, clientDocument: ClientDocument<String>) -> ClientDocument<String> {
        let results = dmp.patch_apply(patchesFrom(edit), toString: clientDocument.content)
        return ClientDocument<String>(id: clientDocument.id, clientId: clientDocument.clientId, content: results[0] as String)
    }

    public func patchShadow(edit: DiffMatchPatchEdit, shadow: ShadowDocument<String>) -> ShadowDocument<String> {
        return ShadowDocument(clientVersion: edit.clientVersion, serverVersion: shadow.serverVersion, clientDocument: patchDocument(edit, clientDocument: shadow.clientDocument))
    }

    public func serverDiff(serverDocument: ClientDocument<String>, shadow: ShadowDocument<String>) -> DiffMatchPatchEdit {
        let diffs = dmp.diff_mainOfOldString(shadow.clientDocument.content, andNewString: serverDocument.content).copy() as [Diff]
        return edit(shadow.clientDocument, shadow: shadow, diffs: diffs)
    }

    private func asDmpDiffs(diffs: [DiffMatchPatchDiff]) -> NSMutableArray {
        var dmpDiffs = NSMutableArray()
        for diff in diffs {
            dmpDiffs.addObject(Diff(operation: asDmpOperation(diff.operation), andText: diff.text))
        }
        return dmpDiffs
    }

    private func patchesFrom(edit: DiffMatchPatchEdit) -> NSArray {
        return dmp.patch_makeFromDiffs(asDmpDiffs(edit.diffs))
    }

    private func asDmpOperation(op: DiffMatchPatchDiff.Operation) -> Operation {
        switch op {
        case .Delete:
            return Operation.DiffDelete
        case .Add:
            return Operation.DiffInsert
        case .Unchanged:
            return Operation.DiffEqual
        }
    }

    private func asAeroGearDiffs(diffs: [Diff]) -> [DiffMatchPatchDiff] {
        return (diffs).map {
            DiffMatchPatchDiff(operation: DiffMatchPatchSynchronizer.asAeroGearOperation($0.operation), text: $0.text)
        }
    }

    private func edit(clientDoc: ClientDocument<String>, shadow: ShadowDocument<String>, diffs: [Diff]) -> DiffMatchPatchEdit {
        return DiffMatchPatchEdit(clientId: clientDoc.clientId, documentId: clientDoc.id, clientVersion: shadow.clientVersion, serverVersion: shadow.serverVersion, checksum: "", diffs: asAeroGearDiffs(diffs))
    }

    private class func asAeroGearOperation(op: Operation) -> DiffMatchPatchDiff.Operation {
        switch op {
        case .DiffDelete:
            return DiffMatchPatchDiff.Operation.Delete
        case .DiffInsert:
            return DiffMatchPatchDiff.Operation.Add
        case .DiffEqual:
            return DiffMatchPatchDiff.Operation.Unchanged
        }
    }
    
    public func patchMessageFromJson(json: String) -> DiffMatchPatchMessage? {
        return DiffMatchPatchMessage().fromJson(json)
    }
    
    public func createPatchMessage(id: String, clientId: String, edits: [DiffMatchPatchEdit]) -> DiffMatchPatchMessage? {
        return DiffMatchPatchMessage(id: id, clientId: clientId, edits: edits)
    }
    
    public func addContent(clientDocument:ClientDocument<String>, fieldName:String, inout objectNode:String) {
        objectNode += "\"content\":\(clientDocument.content)"
    }
}
