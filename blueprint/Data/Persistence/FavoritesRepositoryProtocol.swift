//
//  FavoritesRepositoryProtocol.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

protocol FavoritesRepositoryProtocol: Sendable {
    func isFavorite(id: String) -> Bool
    func add(_ poi: POI) throws
    func remove(id: String) throws
    func fetchAll() -> [POI]
}
