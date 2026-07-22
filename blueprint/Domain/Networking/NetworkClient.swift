//
//  NetworkClient.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decoding
    case unknown(Error)
}

protocol NetworkClient: Sendable {
    func data(for request: URLRequest) async throws -> Data
}

final class URLSessionNetworkClient: NetworkClient {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func data(for request: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }

        return data
    }
}
