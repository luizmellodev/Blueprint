//
//  POI.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation
import CoreLocation

struct POI: Hashable, Sendable, Codable {
    let id: String
    let name: String
    let categories: [PlaceCategory]
    let latitude: Double
    let longitude: Double
    let address: String?
    let city: String?
    let country: String?
    let openingHours: String?
    let website: URL?
    let phone: String?
    
    init(
        id: String,
        name: String,
        categories: [PlaceCategory] = [],
        latitude: Double,
        longitude: Double,
        address: String? = nil,
        city: String? = nil,
        country: String? = nil,
        openingHours: String? = nil,
        website: URL? = nil,
        phone: String? = nil
    ) throws {
        guard !id.isEmpty else { throw ValidationError.emptyID }
        guard !name.isEmpty else { throw ValidationError.emptyName }
        guard (-90...90).contains(latitude) else { throw ValidationError.invalidLatitude }
        guard (-180...180).contains(longitude) else { throw ValidationError.invalidLongitude }
        
        self.id = id
        self.name = name
        self.categories = categories
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.city = city
        self.country = country
        self.openingHours = openingHours
        self.website = website
        self.phone = phone
    }
}

extension POI {
    var formattedAddress: String {
        [address, city, country]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
    
    var displayCategories: String {
        categories.map { $0.rawValue.capitalized }.joined(separator: ", ")
    }
    
    static func preview() -> POI {
        try! POI(
            id: "preview-1",
            name: "Museu do Ipiranga",
            categories: [.tourism],
            latitude: -23.5856,
            longitude: -46.6056,
            address: "Parque da Independência",
            city: "São Paulo",
            country: "Brazil",
            openingHours: "Tu-Su 09:00-17:00",
            website: nil,
            phone: nil
        )
    }
}
