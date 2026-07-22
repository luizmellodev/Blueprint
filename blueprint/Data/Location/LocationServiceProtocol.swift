//
//  LocationServiceProtocol.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import CoreLocation

protocol LocationServiceProtocol: AnyObject, Sendable {
    func requestAuthorization() async -> LocationAuthorizationStatus
    func authorizationStatus() -> LocationAuthorizationStatus
    func getCurrentCoordinates() async throws -> CLLocationCoordinate2D
}
