import Foundation

public class DiffMatchPatchSynchronizer: ClientSynchronizer {

    let dmp: DiffMatchPatch
    
    public init() {
        self.dmp = DiffMatchPatch()
    }

    public func clientDiff(clientDocument: ClientDocument<String>, shadow: ShadowDocument<String>) -> Edit {
        let diffs = dmp.diff_mainOfOldString(clientDocument.content, andNewString: shadow.clientDocument.content)
        return edit(shadow.clientDocument, shadow: shadow, diffs: diffs)
    }

    public func patchDocument(edit: Edit, clientDocument: ClientDocument<String>) -> ClientDocument<String> {
        let results = dmp.patch_apply(patchesFrom(edit), toString: clientDocument.content)
        return ClientDocument<String>(id: clientDocument.id, clientId: clientDocument.clientId, content: results[0] as String)
    }

    public func patchShadow(edit: Edit, shadow: ShadowDocument<String>) -> ShadowDocument<String> {
        return ShadowDocument(clientVersion: edit.clientVersion, serverVersion: shadow.serverVersion, clientDocument: patchDocument(edit, clientDocument: shadow.clientDocument))
    }

    public func serverDiff(serverDocument: ClientDocument<String>, shadow: ShadowDocument<String>) -> Edit {
        let diffs = dmp.diff_mainOfOldString(shadow.clientDocument.content, andNewString: serverDocument.content)
        return edit(shadow.clientDocument, shadow: shadow, diffs: diffs)
    }

    private func asDmpDiffs(diffs: [Edit.Diff]) -> NSMutableArray {
        var dmpDiffs = NSMutableArray()
        for diff in diffs {
           dmpDiffs.addObject(Diff(operation: asDmpOperation(diff.operation), andText: diff.text))
        }
        return dmpDiffs
    }

    private func patchesFrom(edit: Edit) -> NSArray {
        return dmp.patch_makeFromDiffs(asDmpDiffs(edit.diffs))
    }

    private func asDmpOperation(op: Edit.Operation) -> Operation {
        switch op {
        case .Delete:
            return Operation.DiffDelete
        case .Add:
            return Operation.DiffInsert
        case .Unchanged:
            return Operation.DiffEqual
        }
    }

    private func asAeroGearDiffs(diffs: NSArray) -> [Edit.Diff] {
        return (diffs as [Diff]).map {
            Edit.Diff(operation: DiffMatchPatchSynchronizer.asAeroGearOperation($0.operation), text: $0.text)
        }
    }

    private func edit(clientDoc: ClientDocument<String>, shadow: ShadowDocument<String>, diffs: NSArray) -> Edit {
        return Edit(clientId: clientDoc.clientId, documentId: clientDoc.id, clientVersion: shadow.clientVersion, serverVersion: shadow.serverVersion, checksum: "", diffs: asAeroGearDiffs(diffs))
    }
    
    private class func asAeroGearOperation(op: Operation) -> Edit.Operation {
        switch op {
        case .DiffDelete:
            return Edit.Operation.Delete
        case .DiffInsert:
            return Edit.Operation.Add
        case .DiffEqual:
            return Edit.Operation.Unchanged
        }
    }

}
