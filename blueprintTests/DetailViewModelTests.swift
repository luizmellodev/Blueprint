//
//  DetailViewModelTests.swift
//  blueprintTests
//
//  Created by Luiz Mello on 24/07/26.
//

import Testing
@testable import blueprint

@MainActor
struct DetailViewModelTests {

    private func makeViewModel(
        poi: POI = .mock(),
        fetchPlaceDetails: MockFetchPlaceDetailsUseCase? = nil,
        favorites: MockFavoritesUseCase? = nil,
        featureFlags: MockFeatureFlagService? = nil
    ) -> DetailViewModel {
        DetailViewModel(
            poi: poi,
            fetchPlaceDetails: fetchPlaceDetails ?? MockFetchPlaceDetailsUseCase(),
            favorites: favorites ?? MockFavoritesUseCase(),
            featureFlags: featureFlags ?? MockFeatureFlagService()
        )
    }

    @Test func initReadsFeatureFlags() {
        let flags = MockFeatureFlagService()
        flags.enabledFlags = [.favorites]

        let viewModel = makeViewModel(featureFlags: flags)

        #expect(viewModel.showFavoriteButton == true)
        #expect(viewModel.showMapView == false)
    }

    @Test func loadDetailsSetsFavoriteAndDetails() async {
        let poi = POI.mock(id: "123")
        let favorites = MockFavoritesUseCase()
        favorites.favorites = [poi]
        let fetch = MockFetchPlaceDetailsUseCase()
        let details = PlaceDetails.mock(poiID: "123")
        fetch.result = .success(details)
        let viewModel = makeViewModel(poi: poi, fetchPlaceDetails: fetch, favorites: favorites)

        await viewModel.loadDetails()

        #expect(viewModel.isFavorite == true)
        #expect(viewModel.details?.poiID == "123")
        #expect(fetch.executeCallCount == 1)
        #expect(fetch.lastPoiID == "123")
    }

    @Test func loadDetailsSilentlyFailsOnFetchError() async {
        let fetch = MockFetchPlaceDetailsUseCase()
        fetch.result = .failure(AppError.networking)
        let viewModel = makeViewModel(fetchPlaceDetails: fetch)

        await viewModel.loadDetails()

        #expect(viewModel.details == nil)
    }

    @Test func toggleFavoriteUpdatesState() {
        let poi = POI.mock(id: "123")
        let favorites = MockFavoritesUseCase()
        let viewModel = makeViewModel(poi: poi, favorites: favorites)

        viewModel.toggleFavorite()

        #expect(viewModel.isFavorite == true)
        #expect(viewModel.favoriteError == nil)
    }

    @Test func toggleFavoriteSetsErrorOnFailure() {
        let poi = POI.mock(id: "123")
        let favorites = MockFavoritesUseCase()
        favorites.shouldThrowOnToggle = true
        let viewModel = makeViewModel(poi: poi, favorites: favorites)

        viewModel.toggleFavorite()

        #expect(viewModel.favoriteError == "Could not save favorite. Please try again.")
    }

    @Test func clearFavoriteErrorResetsError() {
        let favorites = MockFavoritesUseCase()
        favorites.shouldThrowOnToggle = true
        let viewModel = makeViewModel(favorites: favorites)
        viewModel.toggleFavorite()

        viewModel.clearFavoriteError()

        #expect(viewModel.favoriteError == nil)
    }
}
