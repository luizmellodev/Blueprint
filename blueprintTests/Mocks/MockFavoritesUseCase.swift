//
//  MockFavoritesUseCase.swift
//  blueprintTests
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation
@testable import blueprint

@MainActor
final class MockFavoritesUseCase: FavoritesUseCaseProtocol {
    var favorites: [POI] = []
    var shouldThrowOnToggle = false

    func isFavorite(id: String) -> Bool {
        favorites.contains { $0.id == id }
    }

    func toggle(_ poi: POI) throws {
        if shouldThrowOnToggle {
            throw AppError.unknown
        }
        if let index = favorites.firstIndex(where: { $0.id == poi.id }) {
            favorites.remove(at: index)
        } else {
            favorites.append(poi)
        }
    }

    func fetchAll() -> [POI] {
        favorites
    }
}
