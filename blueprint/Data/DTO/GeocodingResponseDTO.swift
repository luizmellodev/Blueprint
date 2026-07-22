//
//  GeocodingResponseDTO.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

struct GeocodingResponseDTO: Decodable, Sendable {
    let features: [GeocodingFeatureDTO]
}
