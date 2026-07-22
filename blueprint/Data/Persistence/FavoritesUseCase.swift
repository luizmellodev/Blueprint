//
//  FavoritesUseCase.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

protocol FavoritesUseCaseProtocol: Sendable {
    func isFavorite(id: String) -> Bool
    func toggle(_ poi: POI) throws
    func fetchAll() -> [POI]
}

struct FavoritesUseCase: FavoritesUseCaseProtocol {
    let repository: any FavoritesRepositoryProtocol

    func isFavorite(id: String) -> Bool {
        repository.isFavorite(id: id)
    }

    func toggle(_ poi: POI) throws {
        if repository.isFavorite(id: poi.id) {
            try repository.remove(id: poi.id)
        } else {
            try repository.add(poi)
        }
    }

    func fetchAll() -> [POI] {
        repository.fetchAll()
    }
}
