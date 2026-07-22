//
//  HomeViewModelPaginationTests.swift
//  blueprintTests
//
//  Created by Luiz Mello on 22/07/26.
//

import Testing
@testable import blueprint

@MainActor
struct HomeViewModelPaginationTests {

    private func makeViewModel(useCase: MockFetchNearbyPOIsUseCase) -> HomeViewModel {
        HomeViewModel(
            fetchNearbyPOIs: useCase,
            searchLocation: MockSearchLocationUseCase(),
            locationService: MockLocationService()
        )
    }

    @Test func hasMoreIsTrueWhenResultFillsPage() async {
        let useCase = MockFetchNearbyPOIsUseCase()
        useCase.result = .success(PagedResult(items: (1...20).map { POI.mock(id: "\($0)") }, hasMore: true))

        let viewModel = makeViewModel(useCase: useCase)
        await viewModel.load()

        #expect(viewModel.hasMore == true)
    }

    @Test func hasMoreIsFalseOnLastPage() async {
        let useCase = MockFetchNearbyPOIsUseCase()
        useCase.result = .success(PagedResult(items: [.mock()], hasMore: false))

        let viewModel = makeViewModel(useCase: useCase)
        await viewModel.load()

        #expect(viewModel.hasMore == false)
    }

    @Test func loadMoreAppendsPOIs() async {
        let firstPage = (1...3).map { POI.mock(id: "\($0)") }
        let secondPage = (4...6).map { POI.mock(id: "\($0)") }

        let useCase = MockFetchNearbyPOIsUseCase()
        useCase.result = .success(PagedResult(items: firstPage, hasMore: true))

        let viewModel = makeViewModel(useCase: useCase)
        await viewModel.load()

        useCase.result = .success(PagedResult(items: secondPage, hasMore: false))
        await viewModel.loadMore()

        #expect(viewModel.state == .success(firstPage + secondPage))
    }

    @Test func loadMoreDoesNothingWhenHasMoreIsFalse() async {
        let useCase = MockFetchNearbyPOIsUseCase()
        useCase.result = .success(PagedResult(items: [.mock()], hasMore: false))

        let viewModel = makeViewModel(useCase: useCase)
        await viewModel.load()
        await viewModel.loadMore()

        #expect(useCase.executeCallCount == 1)
    }

    @Test func refreshResetsAndReloads() async {
        let useCase = MockFetchNearbyPOIsUseCase()
        useCase.result = .success(PagedResult(items: [.mock()], hasMore: false))

        let viewModel = makeViewModel(useCase: useCase)
        await viewModel.load()
        await viewModel.refresh()

        #expect(useCase.executeCallCount == 2)
        if case .success(let pois) = viewModel.state {
            #expect(pois.count == 1)
        } else {
            Issue.record("Expected success state after refresh")
        }
    }
}
