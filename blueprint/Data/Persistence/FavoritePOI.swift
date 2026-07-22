//
//  FavoritePOI.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

// TODO: Explicar porque FavoritePOI existe separado do POI do domínio (@Model não pertence ao Domain)

import SwiftData

@Model
final class FavoritePOI {
    var id: String
    var name: String
    var categoriesRaw: String
    var latitude: Double
    var longitude: Double
    var address: String?
    var city: String?
    var country: String?

    init(from poi: POI) {
        self.id = poi.id
        self.name = poi.name
        self.categoriesRaw = poi.categories.map(\.rawValue).joined(separator: ",")
        self.latitude = poi.latitude
        self.longitude = poi.longitude
        self.address = poi.address
        self.city = poi.city
        self.country = poi.country
    }

    var poi: POI {
        let categories = categoriesRaw
            .split(separator: ",")
            .map { PlaceCategory(rawValue: String($0)) }
        return POI(
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
