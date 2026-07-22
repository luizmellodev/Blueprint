//
//  FavoritesFactory.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import SwiftUI

@MainActor
final class FavoritesFactory {
    private let persistence: PersistenceDependencies

    init(persistence: PersistenceDependencies) {
        self.persistence = persistence
    }

    func makeView(router: any RouterProtocol) -> some View {
        let viewModel = FavoritesViewModel(favorites: persistence.favoritesUseCase)
        return FavoritesView(viewModel: viewModel, router: router)
    }
}
