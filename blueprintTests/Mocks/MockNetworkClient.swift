//
//  MockNetworkClient.swift
//  blueprintTests
//
//  Created by Luiz Mello on 24/07/26.
//

import Foundation
import Networking

final class MockNetworkClient: NetworkClient, @unchecked Sendable {
    var result: Result<Data, Error> = .success(Data())
    var lastRequest: URLRequest?
    var callCount = 0

    func data(for request: URLRequest) async throws -> Data {
        callCount += 1
        lastRequest = request
        return try result.get()
    }
}
