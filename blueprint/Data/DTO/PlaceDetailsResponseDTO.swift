//
//  PlaceDetailsResponseDTO.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

struct PlaceDetailsResponseDTO: Decodable, Sendable {
    let features: [PlaceDetailsFeatureDTO]
}
