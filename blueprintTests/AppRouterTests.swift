//
//  AppRouterTests.swift
//  blueprintTests
//
//  Created by Luiz Mello on 24/07/26.
//

import Testing
@testable import blueprint

@MainActor
struct AppRouterTests {

    @Test func pushAppendsRoute() {
        let router = AppRouter()

        router.push(.home)

        #expect(router.path == [.home])
    }

    @Test func pushIgnoresConsecutiveDuplicateRoutes() {
        let router = AppRouter()
        router.push(.home)

        router.push(.home)

        #expect(router.path == [.home])
    }

    @Test func pushAllowsSameRouteAfterDifferentRoute() {
        let router = AppRouter()
        let poi = POI.mock()

        router.push(.home)
        router.push(.detail(poi: poi))
        router.push(.home)

        #expect(router.path == [.home, .detail(poi: poi), .home])
    }

    @Test func popRemovesLastRoute() {
        let router = AppRouter()
        router.push(.home)
        router.push(.detail(poi: .mock()))

        router.pop()

        #expect(router.path == [.home])
    }

    @Test func popToRootClearsPath() {
        let router = AppRouter()
        router.push(.home)
        router.push(.detail(poi: .mock()))

        router.popToRoot()

        #expect(router.path.isEmpty)
    }
}
