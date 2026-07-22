//
//  HomeViewModel.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

// TODO: Explicar porque usamos @Observable ao invés de ObservableObject
// TODO: Explicar o guard case .idle para evitar reload ao voltar da navegação
// TODO: Explicar o padrão de debounce com Task.sleep + cancel (sem dependência externa)
// TODO: Explicar a estratégia de pagination com offset

import Foundation
import CoreLocation

@MainActor
@Observable
final class HomeViewModel {
    private(set) var state: HomeUIState = .idle
    private(set) var isLoadingMore = false
    private(set) var hasMore = false
    var searchQuery: String = ""

    private let fetchNearbyPOIs: FetchNearbyPOIsUseCaseProtocol
    private let locationService: any LocationServiceProtocol
    private var allPOIs: [POI] = []
    private var currentOffset = 0
    private let pageSize = 20
    private var searchTask: Task<Void, Never>?
    private var lastCoordinates: (latitude: Double, longitude: Double)?

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
        await fetch(offset: 0)
    }

    func refresh() async {
        currentOffset = 0
        allPOIs = []
        await fetch(offset: 0)
    }

    func loadMore() async {
        guard hasMore, !isLoadingMore else { return }
        isLoadingMore = true
        defer { isLoadingMore = false }
        await fetch(offset: currentOffset)
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
            state = .success(visiblePOIs)
        }
    }

    private func fetch(offset: Int) async {
        if offset == 0 { state = .loading }

        do {
            let coordinates = try await resolveCoordinates()
            lastCoordinates = coordinates
            let result = try await fetchNearbyPOIs.execute(
                lat: coordinates.latitude,
                lon: coordinates.longitude,
                limit: pageSize,
                offset: offset
            )
            allPOIs = offset == 0 ? result.items : allPOIs + result.items
            currentOffset = allPOIs.count
            hasMore = result.hasMore
            state = .success(allPOIs)
        } catch {
            state = .failure(.networking)
        }
    }

    private func resolveCoordinates() async throws -> (latitude: Double, longitude: Double) {
        if let last = lastCoordinates { return last }
        let status = await locationService.requestAuthorization()
        guard status == .authorized else {
            return (latitude: -23.5505, longitude: -46.6333)
        }
        let coords = try await locationService.getCurrentCoordinates()
        return (latitude: coords.latitude, longitude: coords.longitude)
    }
}
