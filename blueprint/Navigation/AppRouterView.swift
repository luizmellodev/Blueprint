//
//  AppRouterView.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import SwiftUI

struct AppRouterView: View {
    @State private var homeRouter = AppRouter()
    @State private var favoritesRouter = AppRouter()
    @State private var container = DIContainer()
    @Namespace private var zoomNamespace

    private var showFavoritesTab: Bool {
        container.featureFlags.service.isEnabled(.favorites)
    }

    var body: some View {
        TabView {
            discoverTab
            if showFavoritesTab {
                favoritesTab
            }
        }
    }

    private var discoverTab: some View {
        NavigationStack(path: $homeRouter.path) {
            container.homeFactory.makeView(router: homeRouter, namespace: zoomNamespace)
                .navigationDestination(for: AppRoute.self) { route in
                    routeDestination(for: route, router: homeRouter)
                }
        }
        .tabItem {
            Label("Discover", systemImage: "map")
        }
    }

    private var favoritesTab: some View {
        NavigationStack(path: $favoritesRouter.path) {
            container.favoritesFactory.makeView(router: favoritesRouter)
                .navigationDestination(for: AppRoute.self) { route in
                    routeDestination(for: route, router: favoritesRouter)
                }
        }
        .tabItem {
            Label("Favorites", systemImage: "heart.fill")
        }
    }

    @ViewBuilder
    private func routeDestination(for route: AppRoute, router: AppRouter) -> some View {
        switch route {
        case .home:
            container.homeFactory.makeView(router: router, namespace: zoomNamespace)
        case .detail(let poi):
            container.detailFactory.makeView(poi: poi)
                .zoomDestination(id: poi.id, namespace: zoomNamespace)
        }
    }
}
