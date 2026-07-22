//
//  NetworkClient.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

protocol NetworkClient: Sendable {
    func data(for request: URLRequest) async throws -> Data
}
