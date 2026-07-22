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

    init(persistence: PersistenceDependencies) {
        self.persistence = persistence
    }

    func makeView(poi: POI) -> some View {
        let viewModel = DetailViewModel(poi: poi, favorites: persistence.favoritesUseCase)
        return DetailView(viewModel: viewModel)
    }
}
