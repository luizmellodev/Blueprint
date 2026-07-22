//
//  AppRouter.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import SwiftUI

// TODO: Explicar porque usamos @Observable ao invés de ObservableObject para o Router
// TODO: Explicar porque o Router fica no app target e não em um Package
@MainActor
@Observable
final class AppRouter: RouterProtocol {
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
