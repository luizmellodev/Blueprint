//
//  POICacheService.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

// TODO: Explicar porque @MainActor ao invés de actor — com SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor
// todos os tipos do módulo são implicitamente @MainActor; usar actor isolado exigiria marcar
// CacheEntry, Logger e outros helpers como nonisolated explicitamente, adicionando ruído sem ganho real
// TODO: Explicar a estratégia de TTL e porque 5 minutos

import Foundation
import OSLog

@MainActor
final class POICacheService {
    private let fileName = "poi_cache.json"
    private let maxAgeSeconds: TimeInterval = 300

    private var cacheURL: URL? {
        FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appending(path: fileName)
    }

    func save(_ pois: [POI]) {
        guard let url = cacheURL else { return }
        let entry = CacheEntry(pois: pois, savedAt: Date())
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
        return entry.pois
    }
}

// MARK: - Private types

private struct CacheEntry: Codable, Sendable {
    let pois: [POI]
    let savedAt: Date
}
