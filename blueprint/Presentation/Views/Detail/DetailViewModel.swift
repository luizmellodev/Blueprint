//
//  DetailViewModel.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

@MainActor
@Observable
final class DetailViewModel {
    private(set) var state: DetailUIState
    private(set) var isFavorite: Bool = false

    private let favorites: any FavoritesUseCaseProtocol

    init(poi: POI, favorites: any FavoritesUseCaseProtocol) {
        self.state = .success(poi)
        self.favorites = favorites
        self.isFavorite = favorites.isFavorite(id: poi.id)
    }

    func toggleFavorite() {
        guard case .success(let poi) = state else { return }
        try? favorites.toggle(poi)
        isFavorite = favorites.isFavorite(id: poi.id)
    }
}
