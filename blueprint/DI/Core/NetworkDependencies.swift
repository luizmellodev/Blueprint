//
//  NetworkDependencies.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

final class NetworkDependencies {
    let client: NetworkClient

    init() {
        self.client = URLSessionNetworkClient()
    }
}
