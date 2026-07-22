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

    init(persistence: PersistenceDependencies, featureFlags: FeatureFlagDependencies) {
        self.persistence = persistence
        self.featureFlags = featureFlags
    }

    func makeView(poi: POI) -> some View {
        let viewModel = DetailViewModel(
            poi: poi,
            favorites: persistence.favoritesUseCase,
            featureFlags: featureFlags.service
        )
        return DetailView(viewModel: viewModel)
    }
}
