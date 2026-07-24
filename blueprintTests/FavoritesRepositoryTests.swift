//
//  FavoritesRepositoryTests.swift
//  blueprintTests
//
//  Created by Luiz Mello on 24/07/26.
//

import SwiftData
import Testing
@testable import blueprint

@MainActor
struct FavoritesRepositoryTests {

    private func makeRepository() throws -> FavoritesRepository {
        let schema = Schema([FavoritePOI.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: configuration)
        return FavoritesRepository(context: ModelContext(container))
    }

    @Test func addPersistsFavorite() throws {
        let repository = try makeRepository()
        let poi = POI.mock(id: "1")

        try repository.add(poi)

        #expect(repository.isFavorite(id: "1") == true)
    }

    @Test func addIsIdempotent() throws {
        let repository = try makeRepository()
        let poi = POI.mock(id: "1")

        try repository.add(poi)
        try repository.add(poi)

        #expect(repository.fetchAll().count == 1)
    }

    @Test func removeDeletesFavorite() throws {
        let repository = try makeRepository()
        let poi = POI.mock(id: "1")
        try repository.add(poi)

        try repository.remove(id: "1")

        #expect(repository.isFavorite(id: "1") == false)
    }

    @Test func removeIsNoOpForUnknownId() throws {
        let repository = try makeRepository()

        try repository.remove(id: "missing")

        #expect(repository.fetchAll().isEmpty)
    }

    @Test func fetchAllReturnsSavedPOIs() throws {
        let repository = try makeRepository()
        let first = POI.mock(id: "1")
        let second = POI.mock(id: "2")
        try repository.add(first)
        try repository.add(second)

        let favorites = repository.fetchAll()

        #expect(favorites.map(\.id) == ["1", "2"])
    }

    @Test func favoritePOIRoundTripsCategories() throws {
        let repository = try makeRepository()
        let poi = POI.mock(id: "1", categories: [.tourism, .catering])

        try repository.add(poi)

        #expect(repository.fetchAll().first?.categories == [.tourism, .catering])
    }
}
