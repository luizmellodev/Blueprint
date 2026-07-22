//
//  PlaceDetailsPropertiesDTO.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

struct PlaceDetailsPropertiesDTO: Decodable, Sendable {
    let place_id: String
    let address_line1: String?
    let address_line2: String?
    let fee: Bool?
    let facilities: PlaceDetailsFacilitiesDTO?
    let wiki_and_media: PlaceDetailsWikiMediaDTO?
    let timezone: PlaceDetailsTimezoneDTO?
}

struct PlaceDetailsFacilitiesDTO: Decodable, Sendable {
    let wheelchair: Bool?
}

struct PlaceDetailsWikiMediaDTO: Decodable, Sendable {
    let wikidata: String?
    let wikipedia: String?
}

struct PlaceDetailsTimezoneDTO: Decodable, Sendable {
    let name: String?
}
