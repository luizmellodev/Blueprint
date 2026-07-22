//
//  GeoapifyGeometryDTO.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

struct GeoapifyGeometryDTO: Decodable, Sendable {
    let coordinates: [Double]
}
