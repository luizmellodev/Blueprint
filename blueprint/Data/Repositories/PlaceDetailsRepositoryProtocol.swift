//
//  PlaceDetailsRepositoryProtocol.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

protocol PlaceDetailsRepositoryProtocol: Sendable {
    func fetchDetails(for poiID: String) async throws -> PlaceDetails
}
