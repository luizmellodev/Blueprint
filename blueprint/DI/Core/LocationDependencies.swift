//
//  LocationDependencies.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

final class LocationDependencies {
    let locationService: any LocationServiceProtocol

    init() {
        self.locationService = LocationService()
    }
}
