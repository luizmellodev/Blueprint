//
//  PlaceDetails+Mock.swift
//  blueprintTests
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation
@testable import blueprint

extension PlaceDetails {
    static func mock(
        poiID: String = "mock-poi-id",
        wikipediaURL: URL? = nil,
        wikidataID: String? = nil,
        isWheelchairAccessible: Bool? = nil,
        fee: Bool? = nil,
        timezone: String? = "America/Sao_Paulo",
        addressLine1: String? = "Rua Mock, 123",
        addressLine2: String? = "São Paulo, SP"
    ) -> PlaceDetails {
        PlaceDetails(
            poiID: poiID,
            wikipediaURL: wikipediaURL,
            wikidataID: wikidataID,
            isWheelchairAccessible: isWheelchairAccessible,
            fee: fee,
            timezone: timezone,
            addressLine1: addressLine1,
            addressLine2: addressLine2
        )
    }
}
