//
//  PlaceDetails.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

// TODO: Explicar porque PlaceDetails é uma entidade separada de POI (dados extras do segundo endpoint)

import Foundation

struct PlaceDetails: Sendable {
    let poiID: String
    let wikipediaURL: URL?
    let wikidataID: String?
    let isWheelchairAccessible: Bool?
    let fee: Bool?
    let timezone: String?
    let addressLine1: String?
    let addressLine2: String?
}
