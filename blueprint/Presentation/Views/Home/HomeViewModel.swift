//
//  HomeViewModel.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import CoreLocation
// TODO: Explicar porque usamos @Observable ao invés de ObservableObject
// TODO: Explicar o guard case .idle para evitar reload ao voltar da navegação
// TODO: Explicar o padrão de debounce com Task.sleep + cancel (sem dependência externa)
// TODO: Explicar a estratégia de pagination com offset
import Foundation

@MainActor
@Observable
final class HomeViewModel {
    private(set) var state: HomeUIState = .idle
    private(set) var isLoadingMore = false
    private(set) var hasMore = false
    private(set) var locationSuggestions: [GeocodingResult] = []
    private(set) var isSearchingLocation = false
    private(set) var visiblePOIs: [POI] = []
    var searchQuery: String = ""
    var locationQuery: String = ""

    private let fetchNearbyPOIs: FetchNearbyPOIsUseCaseProtocol
    private let searchLocation: SearchLocationUseCaseProtocol
    private let locationService: any LocationServiceProtocol
    private var allPOIs: [POI] = []
    private var currentOffset = 0
    private let pageSize = 20
    private var searchTask: Task<Void, Never>?
    private var locationSearchTask: Task<Void, Never>?
    private var lastCoordinates: (latitude: Double, longitude: Double)?

    init(
        fetchNearbyPOIs: FetchNearbyPOIsUseCaseProtocol,
        searchLocation: SearchLocationUseCaseProtocol,
        locationService: any LocationServiceProtocol
    ) {
        self.fetchNearbyPOIs = fetchNearbyPOIs
        self.searchLocation = searchLocation
        self.locationService = locationService
    }

    func load() async {
        guard case .idle = state else { return }
        await fetch(offset: 0)
    }

    func refresh() async {
        currentOffset = 0
        allPOIs = []
        visiblePOIs = []
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
            guard case .success = state else { return }
            visiblePOIs = filtered(allPOIs)
        }
    }

    func onLocationQueryChanged() {
        locationSearchTask?.cancel()
        guard !locationQuery.trimmingCharacters(in: .whitespaces).isEmpty else {
            locationSuggestions = []
            return
        }
        locationSearchTask = Task {
            try? await Task.sleep(for: .milliseconds(400))
            guard !Task.isCancelled else { return }
            isSearchingLocation = true
            defer { isSearchingLocation = false }
            locationSuggestions = (try? await searchLocation.execute(query: locationQuery)) ?? []
        }
    }

    func selectLocation(_ result: GeocodingResult) async {
        locationQuery = result.displayName
        locationSuggestions = []
        lastCoordinates = (latitude: result.latitude, longitude: result.longitude)
        currentOffset = 0
        allPOIs = []
        await fetch(offset: 0)
    }

    func clearLocationSearch() {
        locationQuery = ""
        locationSuggestions = []
        lastCoordinates = nil
        state = .idle
        Task { await load() }
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
            visiblePOIs = filtered(allPOIs)
            state = .success
        } catch {
            state = .failure(.networking)
        }
    }

    private func filtered(_ pois: [POI]) -> [POI] {
        guard !searchQuery.isEmpty else { return pois }
        return pois.filter {
            $0.name.localizedCaseInsensitiveContains(searchQuery) ||
            ($0.city ?? "").localizedCaseInsensitiveContains(searchQuery)
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
