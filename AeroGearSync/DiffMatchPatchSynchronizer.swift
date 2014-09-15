import Foundation

public class DiffMatchPatchSynchronizer: ClientSynchronizer {

    typealias ContentType = String
    let dmp: DiffMatchPatch
    
    public init() {
        self.dmp = DiffMatchPatch()
    }

    public func clientDiff(clientDocument: ClientDocument<String>, shadow: ShadowDocument<String>) {
    }

    public func patchDocument(edit: Edit, clientDocument: ClientDocument<String>) {
    }

    public func patchShadow(edit: Edit, shadow: ShadowDocument<String>) {
    }

    public func serverDiff(serverDocument: ClientDocument<String>, shadow: ShadowDocument<String>) -> Edit {
        let diffs = dmp.diff_mainOfOldString(shadow.clientDocument.content, andNewString: serverDocument.content)
        return Edit(clientId: shadow.clientDocument.clientId, documentId: shadow.clientDocument.id, clientVersion: shadow.clientVersion, serverVersion: shadow.serverVersion, checksum: "", diffs: asAeroGearDiffs(diffs))
    }
    
    func asAeroGearDiffs(diffs: NSArray) -> [Edit.Diff] {
        var aerogearDiffs = Array<Edit.Diff>()
        for diff in diffs {
            aerogearDiffs.append(Edit.Diff(operation: DiffMatchPatchSynchronizer.asAeroGearOperation(diff.operation), text: diff.text));
        }
        return aerogearDiffs
    }
    
    class func asAeroGearOperation(op: Operation) -> Edit.Operation {
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
