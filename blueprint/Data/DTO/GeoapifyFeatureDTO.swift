//
//  GeoapifyFeatureDTO.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

struct GeoapifyFeatureDTO: Decodable, Sendable {
    let properties: GeoapifyPropertiesDTO
    let geometry: GeoapifyGeometryDTO
}
