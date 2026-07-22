//
//  PlaceDetailsRepository.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation
import Networking

final class PlaceDetailsRepository: PlaceDetailsRepositoryProtocol {
    private let client: NetworkClient
    private let apiKey: String

    init(client: NetworkClient, apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }

    func fetchDetails(for poiID: String) async throws -> PlaceDetails {
        guard var components = URLComponents(string: "https://api.geoapify.com/v2/place-details") else {
            throw NetworkError.invalidURL
        }

        components.queryItems = [
            .init(name: "id", value: poiID),
            .init(name: "apiKey", value: apiKey)
        ]

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let data = try await client.data(for: request)

        let decoded: PlaceDetailsResponseDTO
        do {
            decoded = try JSONDecoder().decode(PlaceDetailsResponseDTO.self, from: data)
        } catch {
            throw NetworkError.decoding
        }

        guard let feature = decoded.features.first else {
            throw NetworkError.invalidResponse
        }

        return PlaceDetailsMapper.map(dto: feature)
    }
}
