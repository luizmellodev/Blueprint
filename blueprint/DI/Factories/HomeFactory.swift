//
//  HomeFactory.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import SwiftUI

@MainActor
final class HomeFactory {
    private let poi: POIDependencies
    private let location: LocationDependencies
    private let persistence: PersistenceDependencies
    private let featureFlags: FeatureFlagDependencies

    init(
        poi: POIDependencies,
        location: LocationDependencies,
        persistence: PersistenceDependencies,
        featureFlags: FeatureFlagDependencies
    ) {
        self.poi = poi
        self.location = location
        self.persistence = persistence
        self.featureFlags = featureFlags
    }

    func makeView(router: any RouterProtocol, namespace: Namespace.ID) -> some View {
        let viewModel = HomeViewModel(
            fetchNearbyPOIs: poi.fetchNearbyPOIs,
            searchLocation: poi.searchLocation,
            locationService: location.locationService
        )
        return HomeView(viewModel: viewModel, router: router, namespace: namespace)
    }
}
