//
//  PlaceDetailsMapper.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

enum PlaceDetailsMapper {
    static func map(dto: PlaceDetailsFeatureDTO) -> PlaceDetails {
        let props = dto.properties
        let wikipediaURL = props.wiki_and_media?.wikipedia.flatMap(URL.init(string:))

        return PlaceDetails(
            poiID: props.place_id,
            wikipediaURL: wikipediaURL,
            wikidataID: props.wiki_and_media?.wikidata,
            isWheelchairAccessible: props.facilities?.wheelchair,
            fee: props.fee,
            timezone: props.timezone?.name,
            addressLine1: props.address_line1,
            addressLine2: props.address_line2
        )
    }
}
