//
//  GeoapifyResponseDTO.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

struct GeoapifyResponseDTO: Decodable, Sendable {
    let features: [GeoapifyFeatureDTO]
}
