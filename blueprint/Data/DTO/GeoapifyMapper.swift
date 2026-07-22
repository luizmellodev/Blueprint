//
//  GeoapifyMapper.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

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
            categories: (props.categories ?? []).compactMap { PlaceCategory(rawValue: $0) },
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

