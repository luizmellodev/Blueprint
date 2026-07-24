//
//  DetailFactoryTests.swift
//  blueprintTests
//
//  Created by Luiz Mello on 24/07/26.
//

import Testing
@testable import blueprint

@MainActor
struct DetailFactoryTests {

    @Test func makeViewBuildsDetailScreen() {
        let container = DIContainer()

        _ = container.detailFactory.makeView(poi: .mock())
    }
}
