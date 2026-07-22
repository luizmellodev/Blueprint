//
//  MockGeocodingRepository.swift
//  blueprintTests
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation
@testable import blueprint

@MainActor
final class MockGeocodingRepository: GeocodingRepositoryProtocol {
    var result: Result<[GeocodingResult], Error> = .success([])
    var searchCallCount = 0
    var lastQuery: String?

    func search(query: String) async throws -> [GeocodingResult] {
        searchCallCount += 1
        lastQuery = query
        return try result.get()
    }
}
