//
//  GeocodingMapper.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

enum GeocodingMapper {
    static func map(dto: GeocodingFeatureDTO) -> GeocodingResult? {
        let props = dto.properties
        guard
            let lat = props.lat,
            let lon = props.lon,
            let name = props.formatted
        else { return nil }

        return GeocodingResult(
            displayName: name,
            latitude: lat,
            longitude: lon,
            city: props.city,
            country: props.country
        )
    }
}
