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

public protocol DataStore {
    
    typealias T
    typealias D

    func saveClientDocument(clientDocument: ClientDocument<T>)
    func getClientDocument(documentId: String, clientId: String) -> ClientDocument<T>?
    
    func saveShadowDocument(shadowDocument: ShadowDocument<T>)
    func getShadowDocument(documentId: String, clientId: String) -> ShadowDocument<T>?
    
    func saveBackupShadowDocument(backupShadowDocument: BackupShadowDocument<T>)
    func getBackupShadowDocument(documentId: String, clientId: String) -> BackupShadowDocument<T>?
    
    func saveEdits(edit: D)
    func getEdits(documentId: String, clientId: String) -> [D]?
    func removeEdit(edit: D)
    func removeEdits(documentId: String, clientId: String)
    
}
