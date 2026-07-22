//
//  POIDependencies.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

final class POIDependencies {
    let fetchNearbyPOIs: FetchNearbyPOIsUseCaseProtocol
    let fetchPlaceDetails: FetchPlaceDetailsUseCaseProtocol
    let searchLocation: SearchLocationUseCaseProtocol

    init(network: NetworkDependencies) {
        let repository = POIRepository(
            client: network.client,
            apiKey: Secrets.geoapifyAPIKey
        )
        let detailsRepository = PlaceDetailsRepository(
            client: network.client,
            apiKey: Secrets.geoapifyAPIKey
        )
        let geocodingRepository = GeocodingRepository(
            client: network.client,
            apiKey: Secrets.geoapifyAPIKey
        )
        self.fetchNearbyPOIs = FetchNearbyPOIsUseCase(repository: repository)
        self.fetchPlaceDetails = FetchPlaceDetailsUseCase(repository: detailsRepository)
        self.searchLocation = SearchLocationUseCase(repository: geocodingRepository)
    }
}
