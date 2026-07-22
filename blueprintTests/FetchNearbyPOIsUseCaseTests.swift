//
//  FetchNearbyPOIsUseCaseTests.swift
//  blueprintTests
//
//  Created by Luiz Mello on 22/07/26.
//

import Testing
@testable import blueprint

@MainActor
struct FetchNearbyPOIsUseCaseTests {

    @Test func returnsPagedResultFromRepository() async throws {
        let repository = MockPOIRepository()
        repository.result = .success([.mock(), .mock(id: "2")])

        let useCase = FetchNearbyPOIsUseCase(repository: repository)
        let result = try await useCase.execute(lat: 0, lon: 0, limit: 20)

        #expect(result.items.count == 2)
        #expect(result.hasMore == false)
    }

    @Test func hasMoreIsTrueWhenResultMatchesLimit() async throws {
        let pois = (1...5).map { POI.mock(id: "\($0)") }
        let repository = MockPOIRepository()
        repository.result = .success(pois)

        let useCase = FetchNearbyPOIsUseCase(repository: repository)
        let result = try await useCase.execute(lat: 0, lon: 0, limit: 5)

        #expect(result.hasMore == true)
    }

    @Test func throwsWhenRepositoryFails() async {
        let repository = MockPOIRepository()
        repository.result = .failure(AppError.networking)

        let useCase = FetchNearbyPOIsUseCase(repository: repository)

        await #expect(throws: AppError.networking) {
            try await useCase.execute(lat: 0, lon: 0, limit: 20)
        }
    }
}
