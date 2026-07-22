//
//  FavoritesUseCaseProtocol.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

@MainActor
protocol FavoritesUseCaseProtocol: Sendable {
    func isFavorite(id: String) -> Bool
    func toggle(_ poi: POI) throws
    func fetchAll() -> [POI]
}
