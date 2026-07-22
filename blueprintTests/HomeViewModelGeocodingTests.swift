//
//  HomeViewModelGeocodingTests.swift
//  blueprintTests
//
//  Created by Luiz Mello on 22/07/26.
//

import Testing
@testable import blueprint

@MainActor
struct HomeViewModelGeocodingTests {

    private func makeViewModel(
        fetchNearbyPOIs: MockFetchNearbyPOIsUseCase = MockFetchNearbyPOIsUseCase(),
        searchLocation: MockSearchLocationUseCase = MockSearchLocationUseCase()
    ) -> HomeViewModel {
        HomeViewModel(
            fetchNearbyPOIs: fetchNearbyPOIs,
            searchLocation: searchLocation,
            locationService: MockLocationService()
        )
    }

    @Test func selectLocationFetchesPOIsAtNewCoordinates() async {
        let fetchUseCase = MockFetchNearbyPOIsUseCase()
        fetchUseCase.result = .success(PagedResult(items: [.mock()], hasMore: false))

        let viewModel = makeViewModel(fetchNearbyPOIs: fetchUseCase)
        let result = GeocodingResult.mock(latitude: 48.8566, longitude: 2.3522, city: "Paris")
        await viewModel.selectLocation(result)

        #expect(fetchUseCase.executeCallCount == 1)
        if case .success = viewModel.state { } else {
            Issue.record("Expected success state after selectLocation")
        }
    }

    @Test func selectLocationUpdatesLocationQuery() async {
        let viewModel = makeViewModel()
        let result = GeocodingResult.mock(displayName: "Paris, France")
        await viewModel.selectLocation(result)

        #expect(viewModel.locationQuery == "Paris, France")
    }

    @Test func clearLocationSearchResetsState() async {
        let fetchUseCase = MockFetchNearbyPOIsUseCase()
        fetchUseCase.result = .success(PagedResult(items: [], hasMore: false))

        let viewModel = makeViewModel(fetchNearbyPOIs: fetchUseCase)
        let result = GeocodingResult.mock()
        await viewModel.selectLocation(result)

        viewModel.clearLocationSearch()

        #expect(viewModel.locationQuery == "")
        #expect(viewModel.locationSuggestions.isEmpty)
    }

    @Test func searchLocationUseCaseReceivesQuery() async throws {
        let searchUseCase = MockSearchLocationUseCase()
        searchUseCase.result = .success([.mock()])

        let viewModel = makeViewModel(searchLocation: searchUseCase)
        viewModel.locationQuery = "Paris"
        viewModel.onLocationQueryChanged()

        try await Task.sleep(for: .milliseconds(800))

        #expect(searchUseCase.lastQuery == "Paris")
    }

    @Test func emptyQueryClearsSuggestions() {
        let viewModel = makeViewModel()
        viewModel.locationQuery = ""
        viewModel.onLocationQueryChanged()

        #expect(viewModel.locationSuggestions.isEmpty)
    }
}
