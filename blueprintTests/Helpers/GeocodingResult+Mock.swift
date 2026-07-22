//
//  GeocodingResult+Mock.swift
//  blueprintTests
//
//  Created by Luiz Mello on 22/07/26.
//

@testable import blueprint

extension GeocodingResult {
    static func mock(
        displayName: String = "São Paulo, Brazil",
        latitude: Double = -23.5505,
        longitude: Double = -46.6333,
        city: String? = "São Paulo",
        country: String? = "Brazil"
    ) -> GeocodingResult {
        GeocodingResult(
            displayName: displayName,
            latitude: latitude,
            longitude: longitude,
            city: city,
            country: country
        )
    }
}
