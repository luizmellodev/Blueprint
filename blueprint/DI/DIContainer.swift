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
        self.homeFactory = HomeFactory()
    }
}
