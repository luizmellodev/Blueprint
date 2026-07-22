//
//  SearchLocationUseCaseTests.swift
//  blueprintTests
//
//  Created by Luiz Mello on 22/07/26.
//

import Testing
@testable import blueprint

@MainActor
struct SearchLocationUseCaseTests {

    @Test func returnsResultsFromRepository() async throws {
        let repository = MockGeocodingRepository()
        repository.result = .success([.mock(displayName: "Paris, France")])

        let useCase = SearchLocationUseCase(repository: repository)
        let results = try await useCase.execute(query: "Paris")

        #expect(results.count == 1)
        #expect(results[0].displayName == "Paris, France")
    }

    @Test func returnsEmptyForBlankQuery() async throws {
        let repository = MockGeocodingRepository()
        let useCase = SearchLocationUseCase(repository: repository)

        let results = try await useCase.execute(query: "   ")

        #expect(results.isEmpty)
        #expect(repository.searchCallCount == 0)
    }

    @Test func trimmesWhitespaceBeforeSearching() async throws {
        let repository = MockGeocodingRepository()
        repository.result = .success([.mock()])

        let useCase = SearchLocationUseCase(repository: repository)
        _ = try await useCase.execute(query: "  Paris  ")

        #expect(repository.lastQuery == "Paris")
    }

    @Test func throwsWhenRepositoryFails() async {
        let repository = MockGeocodingRepository()
        repository.result = .failure(AppError.networking)

        let useCase = SearchLocationUseCase(repository: repository)

        await #expect(throws: AppError.networking) {
            try await useCase.execute(query: "Paris")
        }
    }
}
