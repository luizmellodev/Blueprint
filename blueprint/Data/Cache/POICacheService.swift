//
//  POICacheService.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation
import OSLog

// TODO: Explicar porque usamos actor ao invés de final class para o cache (proteção contra data races)
// TODO: Explicar a estratégia de TTL e porque 5 minutos
actor POICacheService {
    private let fileName = "poi_cache.json"
    private let maxAgeSeconds: TimeInterval = 300 // 5 minutes

    private var cacheURL: URL? {
        FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appending(path: fileName)
    }

    func save(_ pois: [POI]) {
        guard let url = cacheURL else { return }
        let entry = CacheEntry(pois: pois.map(CodablePOI.init), savedAt: Date())
        do {
            try JSONEncoder().encode(entry).write(to: url)
            Logger.cache.info("✓ Saved \(pois.count) POIs to cache")
        } catch {
            Logger.cache.error("✗ Failed to save cache: \(error.localizedDescription)")
        }
    }

    func load() -> [POI]? {
        guard let url = cacheURL,
              let data = try? Data(contentsOf: url),
              let entry = try? JSONDecoder().decode(CacheEntry.self, from: data),
              Date().timeIntervalSince(entry.savedAt) < maxAgeSeconds
        else {
            Logger.cache.info("Cache miss")
            return nil
        }

        Logger.cache.info("✓ Cache hit — \(entry.pois.count) POIs")
        return entry.pois.map(\.poi)
    }
}

// MARK: - Private types

private struct CacheEntry: Codable {
    let pois: [CodablePOI]
    let savedAt: Date
}

private struct CodablePOI: Codable {
    let id: String
    let name: String
    let categories: [String]
    let latitude: Double
    let longitude: Double
    let address: String?
    let city: String?
    let country: String?
    let openingHours: String?
    let website: URL?
    let phone: String?

    init(_ poi: POI) {
        id = poi.id
        name = poi.name
        categories = poi.categories
        latitude = poi.latitude
        longitude = poi.longitude
        address = poi.address
        city = poi.city
        country = poi.country
        openingHours = poi.openingHours
        website = poi.website
        phone = poi.phone
    }

    var poi: POI {
        POI(
            id: id,
            name: name,
            categories: categories,
            latitude: latitude,
            longitude: longitude,
            address: address,
            city: city,
            country: country,
            openingHours: openingHours,
            website: website,
            phone: phone
        )
    }
}
