//
//  GeocodingPropertiesDTO.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

struct GeocodingPropertiesDTO: Decodable, Sendable {
    let formatted: String?
    let lat: Double?
    let lon: Double?
    let city: String?
    let country: String?
}
