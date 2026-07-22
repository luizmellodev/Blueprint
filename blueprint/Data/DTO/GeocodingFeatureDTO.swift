//
//  GeocodingFeatureDTO.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

struct GeocodingFeatureDTO: Decodable, Sendable {
    let properties: GeocodingPropertiesDTO
}
