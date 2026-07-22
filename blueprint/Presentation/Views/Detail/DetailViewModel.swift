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
    private(set) var showFavoriteButton: Bool = false

    private let favorites: any FavoritesUseCaseProtocol

    init(poi: POI, favorites: any FavoritesUseCaseProtocol, featureFlags: any FeatureFlagServiceProtocol) {
        self.state = .success(poi)
        self.favorites = favorites
        self.isFavorite = favorites.isFavorite(id: poi.id)
        self.showFavoriteButton = featureFlags.isEnabled(.favorites)
    }

    func toggleFavorite() {
        guard case .success(let poi) = state else { return }
        try? favorites.toggle(poi)
        isFavorite = favorites.isFavorite(id: poi.id)
    }
}
