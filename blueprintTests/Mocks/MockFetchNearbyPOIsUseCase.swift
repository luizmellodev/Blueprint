//
//  MockFetchNearbyPOIsUseCase.swift
//  blueprintTests
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation
@testable import blueprint

final class MockFetchNearbyPOIsUseCase: FetchNearbyPOIsUseCaseProtocol, @unchecked Sendable {
    var result: Result<PagedResult<POI>, Error> = .success(PagedResult(items: [], hasMore: false))
    var executeCallCount = 0

    func execute(lat: Double, lon: Double, limit: Int) async throws -> PagedResult<POI> {
        executeCallCount += 1
        return try result.get()
    }
}
