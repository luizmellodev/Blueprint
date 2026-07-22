//
//  MockPlaceDetailsRepository.swift
//  blueprintTests
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation
@testable import blueprint

final class MockPlaceDetailsRepository: PlaceDetailsRepositoryProtocol, @unchecked Sendable {
    var result: Result<PlaceDetails, Error> = .success(.mock())
    var fetchCallCount = 0

    func fetchDetails(for poiID: String) async throws -> PlaceDetails {
        fetchCallCount += 1
        return try result.get()
    }
}
