//
//  DIContainer.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import SwiftUI

// TODO: Explicar o padrão DIContainer + Factories e porque não usamos um framework de DI
// TODO: Explicar porque as dependências são agrupadas (NetworkDependencies, POIDependencies) e não injetadas flat
@MainActor
final class DIContainer {
    let homeFactory: HomeFactory
    let detailFactory: DetailFactory

    init() {
        let network = NetworkDependencies()
        let poi = POIDependencies(network: network)
        let location = LocationDependencies()
        let persistence = PersistenceDependencies()
        self.homeFactory = HomeFactory(poi: poi, location: location, persistence: persistence)
        self.detailFactory = DetailFactory(persistence: persistence)
    }
}
