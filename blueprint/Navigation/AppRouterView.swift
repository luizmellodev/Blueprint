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
    @Namespace private var zoomNamespace

    var body: some View {
        NavigationStack(path: $router.path) {
            container.homeFactory.makeView(router: router, namespace: zoomNamespace)
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .home:
                        container.homeFactory.makeView(router: router, namespace: zoomNamespace)
                    case .detail(let poi):
                        container.detailFactory.makeView(poi: poi)
                            .zoomDestination(id: poi.id, namespace: zoomNamespace)
                    }
                }
        }
    }
}
