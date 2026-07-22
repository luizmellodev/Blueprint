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

    init(poi: POIDependencies, location: LocationDependencies, persistence: PersistenceDependencies) {
        self.poi = poi
        self.location = location
        self.persistence = persistence
    }

    func makeView(router: any RouterProtocol) -> some View {
        let viewModel = HomeViewModel(
            fetchNearbyPOIs: poi.fetchNearbyPOIs,
            locationService: location.locationService
        )
        return HomeView(viewModel: viewModel, router: router)
    }
}
