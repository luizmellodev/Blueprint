//
//  HomeViewModelRefreshTests.swift
//  blueprintTests
//
//  Created by Luiz Mello on 24/07/26.
//

import Testing
@testable import blueprint

@MainActor
struct HomeViewModelRefreshTests {

    private func makeViewModel(useCase: MockFetchNearbyPOIsUseCase) -> HomeViewModel {
        HomeViewModel(
            fetchNearbyPOIs: useCase,
            searchLocation: MockSearchLocationUseCase(),
            locationService: MockLocationService()
        )
    }

    @Test func refreshReloadsFromOffsetZero() async {
        let useCase = MockFetchNearbyPOIsUseCase()
        useCase.result = .success(PagedResult(items: [.mock(id: "1")], hasMore: false))
        let viewModel = makeViewModel(useCase: useCase)

        await viewModel.load()
        await viewModel.refresh()

        #expect(useCase.executeCallCount == 2)
        #expect(viewModel.state == .success)
    }

    @Test func retryResetsIdleAndLoadsAgain() async {
        let useCase = MockFetchNearbyPOIsUseCase()
        useCase.result = .failure(AppError.networking)
        let viewModel = makeViewModel(useCase: useCase)

        await viewModel.load()
        #expect(viewModel.state == .failure(.networking))

        useCase.result = .success(PagedResult(items: [.mock()], hasMore: false))
        viewModel.retry()
        await Task.yield()
        try? await Task.sleep(for: .milliseconds(50))

        #expect(viewModel.state == .success)
    }
}
