//
//  POI.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

struct POI: Hashable, Sendable, Codable {
    let id: String
    let name: String
    let categories: [String]
    let latitude: Double
    let longitude: Double
    let address: String?
    let city: String?
    let country: String?
    let openingHours: String?
    let website: URL?
    let phone: String?
}

extension POI {
    static func preview() -> POI {
        POI(
            id: "preview-1",
            name: "Museu do Ipiranga",
            categories: ["tourism.museum"],
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
