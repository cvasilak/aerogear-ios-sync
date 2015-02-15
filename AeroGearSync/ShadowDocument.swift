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

public class ShadowDocument<T>: Printable {
    public let clientVersion: Int
    public let serverVersion: Int
    public let clientDocument: ClientDocument<T>

    public init(clientVersion: Int, serverVersion: Int, clientDocument: ClientDocument<T>) {
        self.clientVersion = clientVersion
        self.serverVersion = serverVersion
        self.clientDocument = clientDocument
    }

    public var description: String {
        return "ShadowDocument[clientVersion=\(clientVersion), serverVersion=\(serverVersion), clientDocument=\(clientDocument)]"
    }
}
