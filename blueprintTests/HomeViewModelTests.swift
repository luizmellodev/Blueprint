//
//  HomeViewModelTests.swift
//  blueprintTests
//
//  Created by Luiz Mello on 22/07/26.
//

import Testing
@testable import blueprint

@MainActor
struct HomeViewModelTests {

    private func makeViewModel(
        fetchNearbyPOIs: MockFetchNearbyPOIsUseCase? = nil,
        searchLocation: MockSearchLocationUseCase? = nil,
        locationService: MockLocationService? = nil
    ) -> HomeViewModel {
        HomeViewModel(
            fetchNearbyPOIs: fetchNearbyPOIs ?? MockFetchNearbyPOIsUseCase(),
            searchLocation: searchLocation ?? MockSearchLocationUseCase(),
            locationService: locationService ?? MockLocationService()
        )
    }

    @Test func startsIdle() {
        let viewModel = makeViewModel()
        #expect(viewModel.state == .idle)
    }

    @Test func loadTransitionsToSuccess() async throws {
        let poi = POI.mock()
        let useCase = MockFetchNearbyPOIsUseCase()
        useCase.result = .success(PagedResult(items: [poi], hasMore: false))

        let viewModel = makeViewModel(fetchNearbyPOIs: useCase)
        await viewModel.load()

        #expect(viewModel.state == .success)
        #expect(viewModel.visiblePOIs == [poi])
    }

    @Test func loadTransitionsToFailureOnError() async throws {
        let useCase = MockFetchNearbyPOIsUseCase()
        useCase.result = .failure(AppError.networking)

        let viewModel = makeViewModel(fetchNearbyPOIs: useCase)
        await viewModel.load()

        #expect(viewModel.state == .failure(.networking))
    }

    @Test func loadDoesNotReloadWhenAlreadyLoaded() async throws {
        let useCase = MockFetchNearbyPOIsUseCase()
        useCase.result = .success(PagedResult(items: [.mock()], hasMore: false))

        let viewModel = makeViewModel(fetchNearbyPOIs: useCase)
        await viewModel.load()
        await viewModel.load()

        #expect(useCase.executeCallCount == 1)
    }
}
