//
//  RouterProtocol.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

@MainActor
protocol RouterProtocol: AnyObject {
    func push(_ route: AppRoute)
    func pop()
    func popToRoot()
}
