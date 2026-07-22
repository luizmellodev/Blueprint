//
//  MockLocationService.swift
//  blueprintTests
//
//  Created by Luiz Mello on 22/07/26.
//

import CoreLocation
@testable import blueprint

final class MockLocationService: LocationServiceProtocol, @unchecked Sendable {
    var authorizationStatusToReturn: LocationAuthorizationStatus = .authorized
    var coordinatesToReturn: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333)
    var shouldThrow = false

    func requestAuthorization() async -> LocationAuthorizationStatus {
        authorizationStatusToReturn
    }

    func authorizationStatus() -> LocationAuthorizationStatus {
        authorizationStatusToReturn
    }

    func getCurrentCoordinates() async throws -> CLLocationCoordinate2D {
        if shouldThrow { throw LocationServiceError.failedToGetLocation }
        return coordinatesToReturn
    }
}
