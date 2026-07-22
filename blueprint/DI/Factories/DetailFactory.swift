//
//  DetailFactory.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import SwiftUI

@MainActor
final class DetailFactory {
    private let persistence: PersistenceDependencies
    private let featureFlags: FeatureFlagDependencies
    private let poi: POIDependencies

    init(persistence: PersistenceDependencies, featureFlags: FeatureFlagDependencies, poi: POIDependencies) {
        self.persistence = persistence
        self.featureFlags = featureFlags
        self.poi = poi
    }

    func makeView(poi: POI) -> some View {
        let viewModel = DetailViewModel(
            poi: poi,
            fetchPlaceDetails: self.poi.fetchPlaceDetails,
            favorites: persistence.favoritesUseCase,
            featureFlags: featureFlags.service
        )
        return DetailView(viewModel: viewModel)
    }
}
