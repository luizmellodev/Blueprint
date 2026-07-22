//
//  AppRouterView.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import SwiftUI

struct AppRouterView: View {
    @State private var router = AppRouter()

    var body: some View {
        NavigationStack(path: $router.path) {
            ContentView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .home:
                        ContentView()
                    }
                }
        }
    }
}
