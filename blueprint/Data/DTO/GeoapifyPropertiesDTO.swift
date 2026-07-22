//
//  GeoapifyPropertiesDTO.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

struct GeoapifyPropertiesDTO: Decodable, Sendable {
    let place_id: String
    let name: String?
    let categories: [String]?
    let formatted: String?
    let city: String?
    let country: String?
    let opening_hours: String?
    let website: String?
    let contact: GeoapifyContactDTO?
}
