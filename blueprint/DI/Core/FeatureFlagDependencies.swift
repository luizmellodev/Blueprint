//
//  FeatureFlagDependencies.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

final class FeatureFlagDependencies {
    let service: any FeatureFlagServiceProtocol

    init() {
        self.service = LocalFeatureFlagService()
    }
}
