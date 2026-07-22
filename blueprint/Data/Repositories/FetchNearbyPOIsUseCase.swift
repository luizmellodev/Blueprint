//
//  FetchNearbyPOIsUseCase.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

protocol FetchNearbyPOIsUseCaseProtocol: Sendable {
    func execute(lat: Double, lon: Double, limit: Int) async throws -> PagedResult<POI>
}

// TODO: Explicar porque UseCase é uma struct e não uma class
// TODO: Explicar o papel do UseCase como ponte entre Repository e ViewModel
struct FetchNearbyPOIsUseCase: FetchNearbyPOIsUseCaseProtocol {
    let repository: POIRepositoryProtocol

    func execute(lat: Double, lon: Double, limit: Int) async throws -> PagedResult<POI> {
        let pois = try await repository.fetchNearby(lat: lat, lon: lon, limit: limit)
        return PagedResult(items: pois, hasMore: pois.count == limit)
    }
}
