//
//  POIRepository.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

final class POIRepository: POIRepositoryProtocol {
    private let client: NetworkClient
    private let apiKey: String
    private let cache = POICacheService()

    init(client: NetworkClient, apiKey: String) {
        self.client = client
        self.apiKey = apiKey
    }

    func fetchNearby(lat: Double, lon: Double, limit: Int) async throws -> [POI] {
        if let cached = cache.load() {
            return cached
        }

        guard var components = URLComponents(string: "https://api.geoapify.com/v2/places") else {
            throw NetworkError.invalidURL
        }

        components.queryItems = [
            .init(name: "categories", value: "tourism,catering,entertainment,leisure"),
            .init(name: "filter", value: "circle:\(lon),\(lat),5000"),
            .init(name: "limit", value: "\(limit)"),
            .init(name: "apiKey", value: apiKey)
        ]

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let data = try await client.data(for: request)

        let decoded: GeoapifyResponseDTO
        do {
            decoded = try JSONDecoder().decode(GeoapifyResponseDTO.self, from: data)
        } catch {
            throw NetworkError.decoding
        }

        let pois = decoded.features.compactMap(GeoapifyMapper.map)
        cache.save(pois)
        return pois
    }
}
