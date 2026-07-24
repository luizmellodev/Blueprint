//
//  FavoritesUseCaseTests.swift
//  blueprintTests
//
//  Created by Luiz Mello on 24/07/26.
//

import Testing
@testable import blueprint

@MainActor
struct FavoritesUseCaseTests {

    @Test func isFavoriteDelegatesToRepository() {
        let repository = MockFavoritesRepository()
        repository.favorites = [.mock(id: "1")]
        let useCase = FavoritesUseCase(repository: repository)

        #expect(useCase.isFavorite(id: "1") == true)
        #expect(useCase.isFavorite(id: "2") == false)
    }

    @Test func toggleAddsWhenNotFavorite() throws {
        let repository = MockFavoritesRepository()
        let poi = POI.mock(id: "1")
        let useCase = FavoritesUseCase(repository: repository)

        try useCase.toggle(poi)

        #expect(repository.addCallCount == 1)
        #expect(repository.removeCallCount == 0)
        #expect(useCase.isFavorite(id: "1") == true)
    }

    @Test func toggleRemovesWhenAlreadyFavorite() throws {
        let repository = MockFavoritesRepository()
        let poi = POI.mock(id: "1")
        repository.favorites = [poi]
        let useCase = FavoritesUseCase(repository: repository)

        try useCase.toggle(poi)

        #expect(repository.removeCallCount == 1)
        #expect(repository.addCallCount == 0)
        #expect(useCase.isFavorite(id: "1") == false)
    }

    @Test func fetchAllDelegatesToRepository() {
        let repository = MockFavoritesRepository()
        repository.favorites = [.mock(id: "1"), .mock(id: "2")]
        let useCase = FavoritesUseCase(repository: repository)

        #expect(useCase.fetchAll().count == 2)
    }

    @Test func togglePropagatesRepositoryError() {
        let repository = MockFavoritesRepository()
        repository.shouldThrowOnAdd = true
        let useCase = FavoritesUseCase(repository: repository)

        #expect(throws: AppError.unknown) {
            try useCase.toggle(.mock())
        }
    }
}
