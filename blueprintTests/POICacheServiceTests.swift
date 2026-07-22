//
//  POICacheServiceTests.swift
//  blueprintTests
//
//  Created by Luiz Mello on 22/07/26.
//

import Testing
@testable import blueprint

@MainActor
struct POICacheServiceTests {

    @Test func loadHitsWhenCoordinatesMatch() {
        let cache = POICacheService()
        let poi = POI.mock(id: "poa")
        cache.save([poi], lat: -30.0346, lon: -51.2177)

        let loaded = cache.load(lat: -30.0346, lon: -51.2177)

        #expect(loaded == [poi])
    }

    @Test func loadMissesWhenCoordinatesDiffer() {
        let cache = POICacheService()
        cache.save([.mock(id: "sp")], lat: -23.5505, lon: -46.6333)

        let loaded = cache.load(lat: -30.0346, lon: -51.2177)

        #expect(loaded == nil)
    }
}
