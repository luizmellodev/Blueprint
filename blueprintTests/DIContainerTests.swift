//
//  DIContainerTests.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Testing
@testable import blueprint

@MainActor
struct DIContainerTests {

    @Test("Container assembles all factories without crashing")
    func containerAssemblesFactories() {
        let container = DIContainer()
        _ = container.homeFactory
        _ = container.detailFactory
    }

    @Test("Each container instance owns independent factories")
    func containerInstancesAreIndependent() {
        let first = DIContainer()
        let second = DIContainer()
        #expect(first.homeFactory !== second.homeFactory)
        #expect(first.detailFactory !== second.detailFactory)
    }
}
