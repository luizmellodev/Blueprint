//
//  DIContainer.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import SwiftUI

@MainActor
final class DIContainer {
    let homeFactory: HomeFactory

    init() {
        let network = NetworkDependencies()
        let poi = POIDependencies(network: network)
        self.homeFactory = HomeFactory(poi: poi)
    }
}
