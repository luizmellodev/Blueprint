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

    init(fetchNearbyPOIs: FetchNearbyPOIsUseCaseProtocol) {
        self.fetchNearbyPOIs = fetchNearbyPOIs
    }

    func load() async {
        guard case .idle = state else { return }
        state = .loading

        do {
            let result = try await fetchNearbyPOIs.execute(
                lat: -23.5505,
                lon: -46.6333,
                limit: 20
            )
            state = .success(result.items)
        } catch {
            state = .failure(.networking)
        }
    }
}
