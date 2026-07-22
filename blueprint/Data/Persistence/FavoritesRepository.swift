//
//  FavoritesRepository.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

// TODO: Explicar porque o Repository abstrai o SwiftData do resto da app

import SwiftData
import Foundation

protocol FavoritesRepositoryProtocol: Sendable {
    func isFavorite(id: String) -> Bool
    func add(_ poi: POI) throws
    func remove(id: String) throws
    func fetchAll() -> [POI]
}

@MainActor
final class FavoritesRepository: FavoritesRepositoryProtocol {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func isFavorite(id: String) -> Bool {
        let descriptor = FetchDescriptor<FavoritePOI>(
            predicate: #Predicate { $0.id == id }
        )
        return (try? context.fetchCount(descriptor)) ?? 0 > 0
    }

    func add(_ poi: POI) throws {
        guard !isFavorite(id: poi.id) else { return }
        context.insert(FavoritePOI(from: poi))
        try context.save()
    }

    func remove(id: String) throws {
        let descriptor = FetchDescriptor<FavoritePOI>(
            predicate: #Predicate { $0.id == id }
        )
        guard let favorite = try? context.fetch(descriptor).first else { return }
        context.delete(favorite)
        try context.save()
    }

    func fetchAll() -> [POI] {
        let descriptor = FetchDescriptor<FavoritePOI>()
        return (try? context.fetch(descriptor))?.map(\.poi) ?? []
    }
}
