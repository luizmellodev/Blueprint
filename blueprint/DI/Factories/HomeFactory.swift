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

    init(poi: POIDependencies) {
        self.poi = poi
    }

    func makeView(router: any RouterProtocol) -> some View {
        let viewModel = HomeViewModel(fetchNearbyPOIs: poi.fetchNearbyPOIs)
        return HomeView(viewModel: viewModel, router: router)
    }
}
