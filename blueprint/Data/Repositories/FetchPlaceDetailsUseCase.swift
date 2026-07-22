//
//  FetchPlaceDetailsUseCase.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

struct FetchPlaceDetailsUseCase: FetchPlaceDetailsUseCaseProtocol {
    let repository: PlaceDetailsRepositoryProtocol

    func execute(poiID: String) async throws -> PlaceDetails {
        try await repository.fetchDetails(for: poiID)
    }
}
