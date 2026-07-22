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

    @Test func startsIdle() {
        let viewModel = HomeViewModel(fetchNearbyPOIs: MockFetchNearbyPOIsUseCase(), locationService: MockLocationService())
        #expect(viewModel.state == .idle)
    }

    @Test func loadTransitionsToSuccess() async throws {
        let poi = POI.mock()
        let useCase = MockFetchNearbyPOIsUseCase()
        useCase.result = .success(PagedResult(items: [poi], hasMore: false))

        let viewModel = HomeViewModel(fetchNearbyPOIs: useCase, locationService: MockLocationService())
        await viewModel.load()

        #expect(viewModel.state == .success([poi]))
    }

    @Test func loadTransitionsToFailureOnError() async throws {
        let useCase = MockFetchNearbyPOIsUseCase()
        useCase.result = .failure(AppError.networking)

        let viewModel = HomeViewModel(fetchNearbyPOIs: useCase, locationService: MockLocationService())
        await viewModel.load()

        #expect(viewModel.state == .failure(.networking))
    }

    @Test func loadDoesNotReloadWhenAlreadyLoaded() async throws {
        let useCase = MockFetchNearbyPOIsUseCase()
        useCase.result = .success(PagedResult(items: [.mock()], hasMore: false))

        let viewModel = HomeViewModel(fetchNearbyPOIs: useCase, locationService: MockLocationService())
        await viewModel.load()
        await viewModel.load()

        #expect(useCase.executeCallCount == 1)
    }
}
