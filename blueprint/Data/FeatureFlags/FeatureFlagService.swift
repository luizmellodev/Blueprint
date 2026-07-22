//
//  FeatureFlagService.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

// TODO: Explicar porque o protocolo permite trocar a implementação local por RemoteConfig sem mudar nada nas Views
// TODO: Explicar como Feature Flags reduzem risco em deploys (ship dark, enable gradually)

protocol FeatureFlagServiceProtocol: Sendable {
    func isEnabled(_ flag: FeatureFlag) -> Bool
}

final class LocalFeatureFlagService: FeatureFlagServiceProtocol {
    private let flags: [FeatureFlag: Bool] = [
        .favorites: true,
        .mapView: false,
        .categoryFilter: false
    ]

    func isEnabled(_ flag: FeatureFlag) -> Bool {
        flags[flag] ?? false
    }
}
