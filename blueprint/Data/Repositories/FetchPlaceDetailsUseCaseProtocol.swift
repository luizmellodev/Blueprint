//
//  FetchPlaceDetailsUseCaseProtocol.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

protocol FetchPlaceDetailsUseCaseProtocol: Sendable {
    func execute(poiID: String) async throws -> PlaceDetails
}
