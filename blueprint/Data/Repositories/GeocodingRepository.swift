//
//  GeocodingRepository.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

final class GeocodingRepository: GeocodingRepositoryProtocol {
    private let client: NetworkClient
    private let apiKey: String

    init(client: NetworkClient, apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }

    func search(query: String) async throws -> [GeocodingResult] {
        guard var components = URLComponents(string: "https://api.geoapify.com/v1/geocode/search") else {
            throw NetworkError.invalidURL
        }

        components.queryItems = [
            .init(name: "text", value: query),
            .init(name: "type", value: "city"),
            .init(name: "limit", value: "5"),
            .init(name: "apiKey", value: apiKey)
        ]

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let data = try await client.data(for: request)

        let decoded: GeocodingResponseDTO
        do {
            decoded = try JSONDecoder().decode(GeocodingResponseDTO.self, from: data)
        } catch {
            throw NetworkError.decoding
        }

        return decoded.features.compactMap(GeocodingMapper.map)
    }
}
