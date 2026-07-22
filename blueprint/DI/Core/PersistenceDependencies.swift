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
    private let container: ModelContainer

    init() {
        let container = try! ModelContainer(for: FavoritePOI.self)
        self.container = container
        let repository = FavoritesRepository(context: container.mainContext)
        self.favoritesUseCase = FavoritesUseCase(repository: repository)
    }
}
