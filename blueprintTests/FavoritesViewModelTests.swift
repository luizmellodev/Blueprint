//
//  FavoritesViewModelTests.swift
//  blueprintTests
//
//  Created by Luiz Mello on 22/07/26.
//

import Testing
@testable import blueprint

@MainActor
struct FavoritesViewModelTests {

    private func makeViewModel(favorites: MockFavoritesUseCase? = nil) -> FavoritesViewModel {
        FavoritesViewModel(favorites: favorites ?? MockFavoritesUseCase())
    }

    @Test func startsIdle() {
        let viewModel = makeViewModel()
        #expect(viewModel.state == .idle)
    }

    @Test func loadShowsEmptyWhenNoFavorites() {
        let viewModel = makeViewModel()
        viewModel.load()
        #expect(viewModel.state == .empty)
        #expect(viewModel.pois.isEmpty)
    }

    @Test func loadShowsSuccessWhenFavoritesExist() {
        let favorites = MockFavoritesUseCase()
        favorites.favorites = [.mock(id: "1")]
        let viewModel = makeViewModel(favorites: favorites)

        viewModel.load()

        #expect(viewModel.state == .success)
        #expect(viewModel.pois.count == 1)
    }

    @Test func removeUpdatesList() {
        let poi = POI.mock(id: "1")
        let favorites = MockFavoritesUseCase()
        favorites.favorites = [poi]
        let viewModel = makeViewModel(favorites: favorites)
        viewModel.load()

        viewModel.remove(poi)

        #expect(viewModel.state == .empty)
        #expect(viewModel.pois.isEmpty)
    }

    @Test func removeFailureSetsFailureState() {
        let poi = POI.mock(id: "1")
        let favorites = MockFavoritesUseCase()
        favorites.favorites = [poi]
        favorites.shouldThrowOnToggle = true
        let viewModel = makeViewModel(favorites: favorites)
        viewModel.load()

        viewModel.remove(poi)

        #expect(viewModel.state == .failure(.unknown))
    }
}
