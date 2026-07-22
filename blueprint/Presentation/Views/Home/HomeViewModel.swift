//
//  HomeViewModel.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

// TODO: Explicar porque usamos @Observable ao invés de ObservableObject
// TODO: Explicar o guard case .idle para evitar reload ao voltar da navegação
// TODO: Explicar o padrão de debounce com Task.sleep + cancel (sem dependência externa)

import Foundation
import CoreLocation

@MainActor
@Observable
final class HomeViewModel {
    private(set) var state: HomeUIState = .idle
    var searchQuery: String = ""

    private let fetchNearbyPOIs: FetchNearbyPOIsUseCaseProtocol
    private let locationService: any LocationServiceProtocol
    private var allPOIs: [POI] = []
    private var searchTask: Task<Void, Never>?

    var visiblePOIs: [POI] {
        guard !searchQuery.isEmpty else { return allPOIs }
        return allPOIs.filter {
            $0.name.localizedCaseInsensitiveContains(searchQuery) ||
            ($0.city ?? "").localizedCaseInsensitiveContains(searchQuery)
        }
    }

    init(fetchNearbyPOIs: FetchNearbyPOIsUseCaseProtocol, locationService: any LocationServiceProtocol) {
        self.fetchNearbyPOIs = fetchNearbyPOIs
        self.locationService = locationService
    }

    func load() async {
        guard case .idle = state else { return }
        await fetch()
    }

    func refresh() async {
        await fetch()
    }

    func retry() {
        state = .idle
        Task { await load() }
    }

    func onSearchQueryChanged() {
        searchTask?.cancel()
        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }
            if visiblePOIs.isEmpty && !searchQuery.isEmpty {
                state = .success([])
            } else {
                state = .success(visiblePOIs)
            }
        }
    }

    private func fetch() async {
        state = .loading
        do {
            let coordinates = try await resolveCoordinates()
            let result = try await fetchNearbyPOIs.execute(
                lat: coordinates.latitude,
                lon: coordinates.longitude,
                limit: 20
            )
            allPOIs = result.items
            state = .success(result.items)
        } catch {
            state = .failure(.networking)
        }
    }

    private func resolveCoordinates() async throws -> (latitude: Double, longitude: Double) {
        let status = await locationService.requestAuthorization()
        guard status == .authorized else {
            return (latitude: -23.5505, longitude: -46.6333)
        }
        let coords = try await locationService.getCurrentCoordinates()
        return (latitude: coords.latitude, longitude: coords.longitude)
    }
}
