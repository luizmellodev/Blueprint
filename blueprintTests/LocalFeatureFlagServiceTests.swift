//
//  LocalFeatureFlagServiceTests.swift
//  blueprintTests
//
//  Created by Luiz Mello on 24/07/26.
//

import Testing
@testable import blueprint

struct LocalFeatureFlagServiceTests {

    @Test func returnsConfiguredDefaults() {
        let service = LocalFeatureFlagService()

        #expect(service.isEnabled(.favorites) == true)
        #expect(service.isEnabled(.mapView) == true)
        #expect(service.isEnabled(.categoryFilter) == false)
    }
}
