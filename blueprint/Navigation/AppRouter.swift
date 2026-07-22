//
//  AppRouter.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import SwiftUI

@MainActor
@Observable
final class AppRouter {
    var path: [AppRoute] = []

    func push(_ route: AppRoute) {
        guard path.last != route else { return }
        path.append(route)
    }

    func pop() {
        _ = path.popLast()
    }

    func popToRoot() {
        path.removeAll()
    }
}
