//
//  GeocodingRepositoryProtocol.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

protocol GeocodingRepositoryProtocol: Sendable {
    func search(query: String) async throws -> [GeocodingResult]
}
