//
//  GeoapifyMapperTests.swift
//  blueprintTests
//
//  Created by Luiz Mello on 22/07/26.
//

import Testing
@testable import blueprint

struct GeoapifyMapperTests {

    @Test func mapsValidDTOToPOI() {
        let dto = GeoapifyFeatureDTO(
            properties: GeoapifyPropertiesDTO(
                place_id: "abc123",
                name: "Museu do Ipiranga",
                categories: ["tourism.museum"],
                formatted: "Parque da Independência, São Paulo",
                city: "São Paulo",
                country: "Brazil",
                opening_hours: "Mo-Su 09:00-17:00",
                website: "https://museupaulista.usp.br",
                contact: GeoapifyContactDTO(phone: "+55 11 2065-8000")
            ),
            geometry: GeoapifyGeometryDTO(coordinates: [-46.6333, -23.5505])
        )

        let poi = GeoapifyMapper.map(dto: dto)

        #expect(poi != nil)
        #expect(poi?.id == "abc123")
        #expect(poi?.name == "Museu do Ipiranga")
        #expect(poi?.latitude == -23.5505)
        #expect(poi?.longitude == -46.6333)
        #expect(poi?.city == "São Paulo")
        #expect(poi?.phone == "+55 11 2065-8000")
    }

    @Test func returnsNilWhenNameIsMissing() {
        let dto = GeoapifyFeatureDTO(
            properties: GeoapifyPropertiesDTO(
                place_id: "abc123",
                name: nil,
                categories: nil,
                formatted: nil,
                city: nil,
                country: nil,
                opening_hours: nil,
                website: nil,
                contact: nil
            ),
            geometry: GeoapifyGeometryDTO(coordinates: [-46.6333, -23.5505])
        )

        #expect(GeoapifyMapper.map(dto: dto) == nil)
    }

    @Test func returnsNilWhenCoordinatesAreEmpty() {
        let dto = GeoapifyFeatureDTO(
            properties: GeoapifyPropertiesDTO(
                place_id: "abc123",
                name: "Lugar",
                categories: nil,
                formatted: nil,
                city: nil,
                country: nil,
                opening_hours: nil,
                website: nil,
                contact: nil
            ),
            geometry: GeoapifyGeometryDTO(coordinates: [])
        )

        #expect(GeoapifyMapper.map(dto: dto) == nil)
    }
}
