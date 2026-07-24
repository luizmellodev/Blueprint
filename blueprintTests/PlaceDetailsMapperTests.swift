//
//  PlaceDetailsMapperTests.swift
//  blueprintTests
//
//  Created by Luiz Mello on 24/07/26.
//

import Foundation
import Testing
@testable import blueprint

struct PlaceDetailsMapperTests {

    @Test func mapsAllFieldsFromDTO() {
        let dto = PlaceDetailsFeatureDTO(
            properties: PlaceDetailsPropertiesDTO(
                place_id: "abc123",
                address_line1: "Rua Mock, 123",
                address_line2: "São Paulo, SP",
                fee: true,
                facilities: PlaceDetailsFacilitiesDTO(wheelchair: true),
                wiki_and_media: PlaceDetailsWikiMediaDTO(
                    wikidata: "Q123",
                    wikipedia: "https://en.wikipedia.org/wiki/Test"
                ),
                timezone: PlaceDetailsTimezoneDTO(name: "America/Sao_Paulo")
            )
        )

        let details = PlaceDetailsMapper.map(dto: dto)

        #expect(details.poiID == "abc123")
        #expect(details.addressLine1 == "Rua Mock, 123")
        #expect(details.addressLine2 == "São Paulo, SP")
        #expect(details.fee == true)
        #expect(details.isWheelchairAccessible == true)
        #expect(details.wikidataID == "Q123")
        #expect(details.wikipediaURL?.absoluteString == "https://en.wikipedia.org/wiki/Test")
        #expect(details.timezone == "America/Sao_Paulo")
    }

    @Test func ignoresEmptyWikipediaURL() {
        let dto = PlaceDetailsFeatureDTO(
            properties: PlaceDetailsPropertiesDTO(
                place_id: "abc123",
                address_line1: nil,
                address_line2: nil,
                fee: nil,
                facilities: nil,
                wiki_and_media: PlaceDetailsWikiMediaDTO(
                    wikidata: nil,
                    wikipedia: ""
                ),
                timezone: nil
            )
        )

        let details = PlaceDetailsMapper.map(dto: dto)

        #expect(details.wikipediaURL == nil)
    }
}
