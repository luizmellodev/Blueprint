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
    private(set) var details: PlaceDetails?
    private(set) var isFavorite: Bool = false
    private(set) var showFavoriteButton: Bool = false
    private(set) var favoriteError: String?

    private let fetchPlaceDetails: FetchPlaceDetailsUseCaseProtocol
    private let favorites: any FavoritesUseCaseProtocol

    init(
        poi: POI,
        fetchPlaceDetails: FetchPlaceDetailsUseCaseProtocol,
        favorites: any FavoritesUseCaseProtocol,
        featureFlags: any FeatureFlagServiceProtocol
    ) {
        self.state = .success(poi)
        self.fetchPlaceDetails = fetchPlaceDetails
        self.favorites = favorites
        self.showFavoriteButton = featureFlags.isEnabled(.favorites)
    }

    func loadDetails() async {
        guard case .success(let poi) = state else { return }
        isFavorite = favorites.isFavorite(id: poi.id)
        do {
            details = try await fetchPlaceDetails.execute(poiID: poi.id)
        } catch {
            // details são opcionais — falha silenciosa, o POI básico ainda aparece
        }
    }

    func toggleFavorite() {
        guard case .success(let poi) = state else { return }
        do {
            try favorites.toggle(poi)
            isFavorite = favorites.isFavorite(id: poi.id)
            favoriteError = nil
        } catch {
            favoriteError = "Could not save favorite. Please try again."
        }
    }

    func clearFavoriteError() {
        favoriteError = nil
    }
}
