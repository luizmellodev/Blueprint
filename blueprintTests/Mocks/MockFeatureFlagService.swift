//
//  MockFeatureFlagService.swift
//  blueprintTests
//
//  Created by Luiz Mello on 24/07/26.
//

@testable import blueprint

final class MockFeatureFlagService: FeatureFlagServiceProtocol, @unchecked Sendable {
    var enabledFlags: Set<FeatureFlag> = [.favorites, .mapView]

    func isEnabled(_ flag: FeatureFlag) -> Bool {
        enabledFlags.contains(flag)
    }
}
