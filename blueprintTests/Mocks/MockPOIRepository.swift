//
//  MockPOIRepository.swift
//  blueprintTests
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation
@testable import blueprint

final class MockPOIRepository: POIRepositoryProtocol, @unchecked Sendable {
    var result: Result<[POI], Error> = .success([])
    var fetchCallCount = 0

    func fetchNearby(lat: Double, lon: Double, limit: Int, offset: Int = 0) async throws -> [POI] {
        fetchCallCount += 1
        return try result.get()
    }
}
