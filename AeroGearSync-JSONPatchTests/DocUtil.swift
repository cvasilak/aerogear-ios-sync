//
//  DefaultDocs.swift
//  AeroGearSync
//
//  Created by Daniel Bevenius on 16/09/14.
//  Copyright (c) 2014 aerogear. All rights reserved.
//

import XCTest
import AeroGearSync

class DocUtil {
    
    let documentId: String
    let clientId: String
    let content: String
    
    convenience init() {
        self.init(documentId: "1234", clientId: "client1", content: "something")
    }
    
    init(documentId: String, clientId: String, content: String) {
        self.clientId = clientId
        self.documentId = documentId
        self.content = content
    }
    
    func document() -> ClientDocument<String> {
        return ClientDocument(id: documentId, clientId: clientId, content: content)
    }
    
    func document<T>(content: T) -> ClientDocument<T> {
        return ClientDocument(id: documentId, clientId: clientId, content: content)
    }
    
    func shadow<T>(content: T) -> ShadowDocument<T> {
        return ShadowDocument(clientVersion: 0, serverVersion: 0, clientDocument: ClientDocument(id: documentId, clientId: clientId, content: content))
    }
    
    func shadow() -> ShadowDocument<String> {
        return ShadowDocument(clientVersion: 0, serverVersion: 0, clientDocument: ClientDocument(id: documentId, clientId: clientId, content: content))
    }
    
    func shadow<T>(doc: ClientDocument<T>) -> ShadowDocument<T> {
        return ShadowDocument(clientVersion: 0, serverVersion: 0, clientDocument: doc)
    }
    
    func backupShadow() -> BackupShadowDocument<String> {
        return BackupShadowDocument<String>(version: 1, shadowDocument: shadow())
    }
    
}
