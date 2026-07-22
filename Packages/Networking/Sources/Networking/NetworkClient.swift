//
//  NetworkClient.swift
//  Networking
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

public protocol NetworkClient: Sendable {
    func data(for request: URLRequest) async throws -> Data
}
