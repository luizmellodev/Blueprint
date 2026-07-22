//
//  FetchNearbyPOIsUseCaseProtocol.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

protocol FetchNearbyPOIsUseCaseProtocol: Sendable {
    func execute(lat: Double, lon: Double, limit: Int) async throws -> PagedResult<POI>
}
