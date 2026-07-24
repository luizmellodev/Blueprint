//
//  GeocodingMapperTests.swift
//  blueprintTests
//
//  Created by Luiz Mello on 24/07/26.
//

import Testing
@testable import blueprint

struct GeocodingMapperTests {

    @Test func mapsValidDTOToGeocodingResult() {
        let dto = GeocodingFeatureDTO(
            properties: GeocodingPropertiesDTO(
                formatted: "São Paulo, Brazil",
                lat: -23.5505,
                lon: -46.6333,
                city: "São Paulo",
                country: "Brazil"
            )
        )

        let result = GeocodingMapper.map(dto: dto)

        #expect(result?.displayName == "São Paulo, Brazil")
        #expect(result?.latitude == -23.5505)
        #expect(result?.longitude == -46.6333)
        #expect(result?.city == "São Paulo")
        #expect(result?.country == "Brazil")
    }

    @Test func returnsNilWhenLatitudeIsMissing() {
        let dto = GeocodingFeatureDTO(
            properties: GeocodingPropertiesDTO(
                formatted: "São Paulo, Brazil",
                lat: nil,
                lon: -46.6333,
                city: "São Paulo",
                country: "Brazil"
            )
        )

        #expect(GeocodingMapper.map(dto: dto) == nil)
    }

    @Test func returnsNilWhenFormattedNameIsMissing() {
        let dto = GeocodingFeatureDTO(
            properties: GeocodingPropertiesDTO(
                formatted: nil,
                lat: -23.5505,
                lon: -46.6333,
                city: "São Paulo",
                country: "Brazil"
            )
        )

        #expect(GeocodingMapper.map(dto: dto) == nil)
    }
}
