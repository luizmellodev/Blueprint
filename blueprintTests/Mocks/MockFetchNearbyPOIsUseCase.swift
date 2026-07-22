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
    var executeCallCount = 0

    func execute(lat: Double, lon: Double, limit: Int, offset: Int = 0) async throws -> PagedResult<POI> {
        executeCallCount += 1
        return try result.get()
    }
}
