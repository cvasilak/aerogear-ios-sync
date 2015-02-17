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

import XCTest
import AeroGearSync

class ClientDocumentTests: XCTestCase {

    func testCreateClientStringDocumentString() {
        let doc = ClientDocument<String>(id: "1234", clientId: "client1", content: "Fletch")
        
        XCTAssertEqual("client1", doc.clientId)
        XCTAssertEqual("1234", doc.id)
        XCTAssertEqual("Fletch", doc.content)
    }
    
    func testCreateClientIntDocumentString() {
        let doc = ClientDocument<Int>(id: "1234", clientId: "client1", content: 777)
        XCTAssertEqual("client1", doc.clientId)
        XCTAssertEqual("1234", doc.id)
        XCTAssertEqual(777, doc.content)
    }

}
