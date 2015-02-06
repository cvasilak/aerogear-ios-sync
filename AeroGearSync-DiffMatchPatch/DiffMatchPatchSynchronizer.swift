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
    
}
