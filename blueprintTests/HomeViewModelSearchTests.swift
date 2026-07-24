//
//  HomeViewModelSearchTests.swift
//  blueprintTests
//
//  Created by Luiz Mello on 24/07/26.
//

import CoreLocation
import Testing
@testable import blueprint

@MainActor
struct HomeViewModelSearchTests {

    private func makeViewModel(
        fetchNearbyPOIs: MockFetchNearbyPOIsUseCase? = nil,
        locationService: MockLocationService? = nil
    ) -> HomeViewModel {
        HomeViewModel(
            fetchNearbyPOIs: fetchNearbyPOIs ?? MockFetchNearbyPOIsUseCase(),
            searchLocation: MockSearchLocationUseCase(),
            locationService: locationService ?? MockLocationService()
        )
    }

    @Test func searchQueryFiltersVisiblePOIs() async throws {
        let useCase = MockFetchNearbyPOIsUseCase()
        useCase.result = .success(PagedResult(items: [
            POI.mock(id: "1", name: "Museum"),
            POI.mock(id: "2", name: "Park")
        ], hasMore: false))
        let viewModel = makeViewModel(fetchNearbyPOIs: useCase)
        await viewModel.load()

        viewModel.searchQuery = "Museum"
        viewModel.onSearchQueryChanged()
        try await Task.sleep(for: .milliseconds(400))

        #expect(viewModel.visiblePOIs.count == 1)
        #expect(viewModel.visiblePOIs[0].name == "Museum")
    }

    @Test func usesFallbackCoordinatesWhenNotAuthorized() async {
        let location = MockLocationService()
        location.authorizationStatusToReturn = .denied
        let useCase = MockFetchNearbyPOIsUseCase()
        useCase.result = .success(PagedResult(items: [.mock()], hasMore: false))
        let viewModel = makeViewModel(fetchNearbyPOIs: useCase, locationService: location)

        await viewModel.load()

        #expect(useCase.lastLat == -23.5505)
        #expect(useCase.lastLon == -46.6333)
    }

    @Test func usesDeviceCoordinatesWhenAuthorized() async {
        let location = MockLocationService()
        location.authorizationStatusToReturn = .authorized
        location.coordinatesToReturn = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
        let useCase = MockFetchNearbyPOIsUseCase()
        useCase.result = .success(PagedResult(items: [.mock()], hasMore: false))
        let viewModel = makeViewModel(fetchNearbyPOIs: useCase, locationService: location)

        await viewModel.load()

        #expect(useCase.lastLat == 40.7128)
        #expect(useCase.lastLon == -74.0060)
    }
}
