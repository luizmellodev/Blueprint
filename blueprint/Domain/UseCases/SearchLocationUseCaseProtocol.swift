//
//  SearchLocationUseCaseProtocol.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

protocol SearchLocationUseCaseProtocol: Sendable {
    func execute(query: String) async throws -> [GeocodingResult]
}
