//
//  FavoritePOI.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

// TODO: Explicar porque FavoritePOI existe separado do POI do domínio (SwiftData @Model não pode entrar na camada Domain)

import SwiftData

@Model
final class FavoritePOI {
    @Attribute(.unique) var id: String
    var name: String
    var categories: [String]
    var latitude: Double
    var longitude: Double
    var address: String?
    var city: String?
    var country: String?

    init(from poi: POI) {
        self.id = poi.id
        self.name = poi.name
        self.categories = poi.categories.map(\.rawValue)
        self.latitude = poi.latitude
        self.longitude = poi.longitude
        self.address = poi.address
        self.city = poi.city
        self.country = poi.country
    }

    var poi: POI {
        POI(
            id: id,
            name: name,
            categories: categories.map(PlaceCategory.init),
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
