//
//  MockFetchPlaceDetailsUseCase.swift
//  blueprintTests
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation
@testable import blueprint

final class MockFetchPlaceDetailsUseCase: FetchPlaceDetailsUseCaseProtocol, @unchecked Sendable {
    var result: Result<PlaceDetails, Error> = .success(.mock())
    var executeCallCount = 0
    var lastPoiID: String?

    func execute(poiID: String) async throws -> PlaceDetails {
        executeCallCount += 1
        lastPoiID = poiID
        return try result.get()
    }
}
