//
//  FavoritesRepository.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

// TODO: Explicar porque o Repository abstrai o SwiftData do resto da app

import SwiftData
import Foundation

@MainActor
final class FavoritesRepository: FavoritesRepositoryProtocol {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func isFavorite(id: String) -> Bool {
        fetchAll().contains { $0.id == id }
    }

    func add(_ poi: POI) throws {
        guard !isFavorite(id: poi.id) else { return }
        context.insert(FavoritePOI(from: poi))
        try context.save()
    }

    func remove(id: String) throws {
        let all = (try? context.fetch(FetchDescriptor<FavoritePOI>())) ?? []
        guard let favorite = all.first(where: { $0.id == id }) else { return }
        context.delete(favorite)
        try context.save()
    }

    func fetchAll() -> [POI] {
        let descriptor = FetchDescriptor<FavoritePOI>()
        return (try? context.fetch(descriptor))?.map(\.poi) ?? []
    }
}
