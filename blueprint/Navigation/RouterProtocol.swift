//
//  RouterProtocol.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

// TODO: Explicar porque Views recebem RouterProtocol e não AppRouter concreto (testabilidade)
@MainActor
protocol RouterProtocol: AnyObject {
    func push(_ route: AppRoute)
    func pop()
    func popToRoot()
}
