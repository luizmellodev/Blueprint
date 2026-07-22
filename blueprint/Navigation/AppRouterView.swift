//
//  AppRouterView.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import SwiftUI

struct AppRouterView: View {
    @State private var router = AppRouter()
    @State private var container = DIContainer()

    var body: some View {
        NavigationStack(path: $router.path) {
            container.homeFactory.makeView(router: router)
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .home:
                        container.homeFactory.makeView(router: router)
                    case .detail(let poi):
                        container.detailFactory.makeView(poi: poi)
                    }
                }
        }
    }
}
