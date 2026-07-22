//
//  HomeViewModel.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

// TODO: Explicar porque usamos @Observable ao invés de ObservableObject
// TODO: Explicar o guard case .idle para evitar reload ao voltar da navegação
@MainActor
@Observable
final class HomeViewModel {
    private(set) var state: HomeUIState = .idle

    private let fetchNearbyPOIs: FetchNearbyPOIsUseCaseProtocol
    private let locationService: any LocationServiceProtocol

    init(fetchNearbyPOIs: FetchNearbyPOIsUseCaseProtocol, locationService: any LocationServiceProtocol) {
        self.fetchNearbyPOIs = fetchNearbyPOIs
        self.locationService = locationService
    }

    func load() async {
        guard case .idle = state else { return }
        state = .loading

        do {
            let coordinates = try await resolveCoordinates()
            let result = try await fetchNearbyPOIs.execute(
                lat: coordinates.latitude,
                lon: coordinates.longitude,
                limit: 20
            )
            state = .success(result.items)
        } catch {
            state = .failure(.networking)
        }
    }

    private func resolveCoordinates() async throws -> (latitude: Double, longitude: Double) {
        let status = await locationService.requestAuthorization()
        guard status == .authorized else {
            return (latitude: -23.5505, longitude: -46.6333) // fallback: São Paulo
        }
        let coords = try await locationService.getCurrentCoordinates()
        return (latitude: coords.latitude, longitude: coords.longitude)
    }
}
