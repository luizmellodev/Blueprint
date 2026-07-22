//
//  GeocodingResult.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

struct GeocodingResult: Sendable, Hashable {
    let displayName: String
    let latitude: Double
    let longitude: Double
    let city: String?
    let country: String?
}
