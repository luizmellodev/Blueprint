//
//  FavoritesViewModel.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

@MainActor
@Observable
final class FavoritesViewModel {
    private(set) var state: FavoritesUIState = .idle
    private(set) var pois: [POI] = []

    private let favorites: any FavoritesUseCaseProtocol

    init(favorites: any FavoritesUseCaseProtocol) {
        self.favorites = favorites
    }

    func load() {
        let all = favorites.fetchAll()
        pois = all
        state = all.isEmpty ? .empty : .success
    }

    func remove(_ poi: POI) {
        do {
            try favorites.toggle(poi)
            load()
        } catch {
            state = .failure(.unknown)
        }
    }
}
