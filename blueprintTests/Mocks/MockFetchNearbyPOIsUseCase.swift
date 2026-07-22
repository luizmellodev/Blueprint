//
//  MockFetchNearbyPOIsUseCase.swift
//  blueprintTests
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation
@testable import blueprint

@MainActor
final class MockFetchNearbyPOIsUseCase: FetchNearbyPOIsUseCaseProtocol {
    var result: Result<PagedResult<POI>, Error> = .success(PagedResult(items: [], hasMore: false))
    var queuedResults: [Result<PagedResult<POI>, Error>] = []
    var firstCallDelayNanoseconds: UInt64 = 0
    var executeCallCount = 0

    func execute(lat: Double, lon: Double, limit: Int, offset: Int = 0) async throws -> PagedResult<POI> {
        executeCallCount += 1
        if executeCallCount == 1, firstCallDelayNanoseconds > 0 {
            try await Task.sleep(nanoseconds: firstCallDelayNanoseconds)
        }
        if executeCallCount <= queuedResults.count {
            return try queuedResults[executeCallCount - 1].get()
        }
        return try result.get()
    }
}
