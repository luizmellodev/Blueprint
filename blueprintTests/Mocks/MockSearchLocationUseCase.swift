//
//  MockSearchLocationUseCase.swift
//  blueprintTests
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation
@testable import blueprint

final class MockSearchLocationUseCase: SearchLocationUseCaseProtocol, @unchecked Sendable {
    var result: Result<[GeocodingResult], Error> = .success([])
    var executeCallCount = 0
    var lastQuery: String?

    func execute(query: String) async throws -> [GeocodingResult] {
        executeCallCount += 1
        lastQuery = query
        return try result.get()
    }
}
