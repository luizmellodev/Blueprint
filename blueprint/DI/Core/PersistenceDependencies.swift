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
        guard let container = try? ModelContainer(for: FavoritePOI.self) else {
            fatalError("ModelContainer failed to initialize — schema migration conflict or storage unavailable")
        }
        self.container = container
        let repository = FavoritesRepository(context: container.mainContext)
        self.favoritesUseCase = FavoritesUseCase(repository: repository)
    }
}
