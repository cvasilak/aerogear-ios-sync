import Foundation

public class DiffMatchPatchSynchronizer: ClientSynchronizer {

    typealias ContentType = String
    let dmp: DiffMatchPatch
    
    public init() {
        self.dmp = DiffMatchPatch()
    }

    public func clientDiff(clientDocument: ClientDocument<String>, shadowDocument: ShadowDocument<String>) {
    }

    public func patchDocument(edit: Edit, clientDocument: ClientDocument<String>) {
    }

    public func patchShadow(edit: Edit, shadowDocument: ShadowDocument<String>) {
    }

    public func serverDiff(serverDocument: ClientDocument<String>, shadowDocument: ShadowDocument<String>) -> PatchMessage {
        let diffs = dmp.diff_mainOfOldString(serverDocument.content, andNewString: shadowDocument.clientDocument.content)
        return PatchMessage(id: serverDocument.id, clientId: serverDocument.clientId, edits: asAeroGearDiffs(diffs))
    }
    
    func asAeroGearDiffs(diffs: NSArray) -> [Edit] {
        var aerogearDiffs = [Edit]()
        for diff in diffs {
            //aergearDiffs.append(Edit.Diff(Edit.Operation.Add)
        }
        return [];
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
