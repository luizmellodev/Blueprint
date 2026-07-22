//
//  URLSessionNetworkClient.swift
//  Networking
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation
import OSLog

public final class URLSessionNetworkClient: NetworkClient {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func data(for request: URLRequest) async throws -> Data {
        let url = request.url?.absoluteString ?? "unknown"
        logger.info("→ \(request.httpMethod ?? "GET") \(url)")

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                logger.error("✗ Invalid response for \(url)")
                throw NetworkError.invalidResponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                logger.error("✗ HTTP \(httpResponse.statusCode) for \(url)")
                throw NetworkError.invalidResponse
            }

            logger.info("✓ HTTP \(httpResponse.statusCode) — \(data.count) bytes from \(url)")
            return data
        } catch let error as NetworkError {
            throw error
        } catch {
            logger.error("✗ Request failed: \(error.localizedDescription)")
            throw NetworkError.unknown(error)
        }
    }
}

private let logger = Logger(subsystem: "dev.luizmello.blueprint", category: "networking")
