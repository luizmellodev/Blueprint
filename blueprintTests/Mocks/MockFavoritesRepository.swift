//
//  MockFavoritesRepository.swift
//  blueprintTests
//
//  Created by Luiz Mello on 24/07/26.
//

import Foundation
@testable import blueprint

@MainActor
final class MockFavoritesRepository: FavoritesRepositoryProtocol {
    var favorites: [POI] = []
    var shouldThrowOnAdd = false
    var shouldThrowOnRemove = false
    var addCallCount = 0
    var removeCallCount = 0

    func isFavorite(id: String) -> Bool {
        favorites.contains { $0.id == id }
    }

    func add(_ poi: POI) throws {
        addCallCount += 1
        if shouldThrowOnAdd {
            throw AppError.unknown
        }
        guard !isFavorite(id: poi.id) else { return }
        favorites.append(poi)
    }

    func remove(id: String) throws {
        removeCallCount += 1
        if shouldThrowOnRemove {
            throw AppError.unknown
        }
        favorites.removeAll { $0.id == id }
    }

    func fetchAll() -> [POI] {
        favorites
    }
}
