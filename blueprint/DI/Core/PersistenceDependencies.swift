//
//  PersistenceDependencies.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import SwiftData

@MainActor
final class PersistenceDependencies {
    let favoritesUseCase: any FavoritesUseCaseProtocol

    init() {
        let container = try! ModelContainer(for: FavoritePOI.self)
        let repository = FavoritesRepository(context: container.mainContext)
        self.favoritesUseCase = FavoritesUseCase(repository: repository)
    }
}
