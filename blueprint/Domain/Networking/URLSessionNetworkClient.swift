//
//  URLSessionNetworkClient.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation
import OSLog

final class URLSessionNetworkClient: NetworkClient {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func data(for request: URLRequest) async throws -> Data {
        let url = request.url?.absoluteString ?? "unknown"
        Logger.networking.info("→ \(request.httpMethod ?? "GET") \(url)")

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                Logger.networking.error("✗ Invalid response for \(url)")
                throw NetworkError.invalidResponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                Logger.networking.error("✗ HTTP \(httpResponse.statusCode) for \(url)")
                throw NetworkError.invalidResponse
            }

            Logger.networking.info("✓ HTTP \(httpResponse.statusCode) — \(data.count) bytes from \(url)")
            return data
        } catch let error as NetworkError {
            throw error
        } catch {
            Logger.networking.error("✗ Request failed: \(error.localizedDescription)")
            throw NetworkError.unknown(error)
        }
    }
}
