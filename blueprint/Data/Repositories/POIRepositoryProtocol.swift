//
//  POIRepositoryProtocol.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

protocol POIRepositoryProtocol: Sendable {
    func fetchNearby(lat: Double, lon: Double, limit: Int) async throws -> [POI]
}
