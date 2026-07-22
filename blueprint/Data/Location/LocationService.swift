//
//  LocationService.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import CoreLocation
import Foundation

@MainActor
final class LocationService: NSObject, LocationServiceProtocol, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var authContinuation: CheckedContinuation<LocationAuthorizationStatus, Never>?
    private var locationContinuation: CheckedContinuation<CLLocationCoordinate2D, Error>?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func requestAuthorization() async -> LocationAuthorizationStatus {
        let current = authorizationStatus()
        guard current == .notDetermined else { return current }
        guard authContinuation == nil else { return .notDetermined }

        return await withCheckedContinuation { continuation in
            self.authContinuation = continuation
            self.manager.requestWhenInUseAuthorization()
        }
    }

    func authorizationStatus() -> LocationAuthorizationStatus {
        switch manager.authorizationStatus {
        case .notDetermined: return .notDetermined
        case .restricted: return .restricted
        case .denied: return .denied
        case .authorizedAlways, .authorizedWhenInUse: return .authorized
        @unknown default: return .denied
        }
    }

    func getCurrentCoordinates() async throws -> CLLocationCoordinate2D {
        guard authorizationStatus() == .authorized else {
            throw LocationServiceError.notAuthorized
        }

        return try await withCheckedThrowingContinuation { continuation in
            self.locationContinuation = continuation
            self.manager.requestLocation()
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let continuation = authContinuation else { return }
        authContinuation = nil
        continuation.resume(returning: authorizationStatus())
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let continuation = locationContinuation else { return }
        locationContinuation = nil
        if let coordinate = locations.first?.coordinate {
            continuation.resume(returning: coordinate)
        } else {
            continuation.resume(throwing: LocationServiceError.failedToGetLocation)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let continuation = locationContinuation else { return }
        locationContinuation = nil
        continuation.resume(throwing: error)
    }
}
