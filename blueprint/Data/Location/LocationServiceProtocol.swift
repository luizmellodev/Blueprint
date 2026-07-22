//
//  LocationServiceProtocol.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import CoreLocation

enum LocationAuthorizationStatus: Sendable {
    case notDetermined
    case authorized
    case denied
    case restricted
}

enum LocationServiceError: Error, Sendable {
    case notAuthorized
    case failedToGetLocation
}

protocol LocationServiceProtocol: AnyObject, Sendable {
    func requestAuthorization() async -> LocationAuthorizationStatus
    func authorizationStatus() -> LocationAuthorizationStatus
    func getCurrentCoordinates() async throws -> CLLocationCoordinate2D
}
