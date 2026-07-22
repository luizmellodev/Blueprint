//
//  GeoapifyDTOs.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

struct GeoapifyResponseDTO: Decodable, Sendable {
    let features: [GeoapifyFeatureDTO]
}

struct GeoapifyFeatureDTO: Decodable, Sendable {
    let properties: GeoapifyPropertiesDTO
    let geometry: GeoapifyGeometryDTO
}

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

struct GeoapifyContactDTO: Decodable, Sendable {
    let phone: String?
}

struct GeoapifyGeometryDTO: Decodable, Sendable {
    let coordinates: [Double]
}

enum GeoapifyMapper {
    static func map(dto: GeoapifyFeatureDTO) -> POI? {
        let props = dto.properties
        let coords = dto.geometry.coordinates

        guard
            let name = props.name,
            coords.count >= 2
        else { return nil }

        return POI(
            id: props.place_id,
            name: name,
            categories: props.categories ?? [],
            latitude: coords[1],
            longitude: coords[0],
            address: props.formatted,
            city: props.city,
            country: props.country,
            openingHours: props.opening_hours,
            website: props.website.flatMap(URL.init(string:)),
            phone: props.contact?.phone
        )
    }
}
