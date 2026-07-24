//
//  FavoritePOITests.swift
//  blueprintTests
//
//  Created by Luiz Mello on 24/07/26.
//

import Testing
@testable import blueprint

struct FavoritePOITests {

    @Test func initStoresFieldsFromPOI() {
        let poi = POI.mock(id: "fav-1")
        let favorite = FavoritePOI(from: poi)

        #expect(favorite.id == "fav-1")
        #expect(favorite.name == poi.name)
        #expect(favorite.latitude == poi.latitude)
        #expect(favorite.longitude == poi.longitude)
    }

    @Test func poiComputedPropertyMapsBackToDomain() {
        let poi = POI.mock(id: "fav-2")
        let favorite = FavoritePOI(from: poi)

        let mapped = favorite.poi

        #expect(mapped.id == poi.id)
        #expect(mapped.name == poi.name)
        #expect(mapped.latitude == poi.latitude)
        #expect(mapped.longitude == poi.longitude)
    }
}
