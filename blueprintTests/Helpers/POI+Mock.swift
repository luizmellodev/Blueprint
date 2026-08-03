//
//  POI+Mock.swift
//  blueprintTests
//
//  Created by Luiz Mello on 22/07/26.
//

@testable import blueprint

extension POI {
    static func mock(
        id: String = "mock-id",
        name: String = "Mock POI",
        categories: [PlaceCategory] = [.tourism],
        latitude: Double = -23.5505,
        longitude: Double = -46.6333,
        address: String? = nil,
        city: String? = nil,
        country: String? = nil
    ) -> POI {
        try! POI(
            id: id,
            name: name,
            categories: categories,
            latitude: latitude,
            longitude: longitude,
            address: address,
            city: city,
            country: country,
            openingHours: nil,
            website: nil,
            phone: nil
        )
    }
}
