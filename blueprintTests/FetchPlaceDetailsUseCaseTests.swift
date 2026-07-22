//
//  FetchPlaceDetailsUseCaseTests.swift
//  blueprintTests
//
//  Created by Luiz Mello on 22/07/26.
//

import Testing
@testable import blueprint

@MainActor
struct FetchPlaceDetailsUseCaseTests {

    @Test func returnsDetailsFromRepository() async throws {
        let repository = MockPlaceDetailsRepository()
        repository.result = .success(.mock(poiID: "abc-123", timezone: "America/Sao_Paulo"))

        let useCase = FetchPlaceDetailsUseCase(repository: repository)
        let details = try await useCase.execute(poiID: "abc-123")

        #expect(details.poiID == "abc-123")
        #expect(details.timezone == "America/Sao_Paulo")
    }

    @Test func throwsWhenRepositoryFails() async {
        let repository = MockPlaceDetailsRepository()
        repository.result = .failure(AppError.networking)

        let useCase = FetchPlaceDetailsUseCase(repository: repository)

        await #expect(throws: AppError.networking) {
            try await useCase.execute(poiID: "any-id")
        }
    }

    @Test func delegatesToRepository() async throws {
        let repository = MockPlaceDetailsRepository()
        repository.result = .success(.mock())

        let useCase = FetchPlaceDetailsUseCase(repository: repository)
        _ = try await useCase.execute(poiID: "test-id")

        #expect(repository.fetchCallCount == 1)
    }
}
