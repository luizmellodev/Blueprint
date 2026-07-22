//
//  POIDependencies.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

final class POIDependencies {
    let fetchNearbyPOIs: FetchNearbyPOIsUseCaseProtocol

    init(network: NetworkDependencies) {
        let repository = POIRepository(
            client: network.client,
            apiKey: Secrets.geoapifyAPIKey
        )
        self.fetchNearbyPOIs = FetchNearbyPOIsUseCase(repository: repository)
    }
}
