//
//  GeocodingRepositoryTests.swift
//  blueprintTests
//
//  Created by Luiz Mello on 24/07/26.
//

import Foundation
import Networking
import Testing
@testable import blueprint

@MainActor
struct GeocodingRepositoryTests {

    private static let geocodingJSON = Data(
        """
        {
          "features": [{
            "properties": {
              "formatted": "São Paulo, Brazil",
              "lat": -23.5505,
              "lon": -46.6333,
              "city": "São Paulo",
              "country": "Brazil"
            }
          }]
        }
        """.utf8
    )

    @Test func returnsMappedResults() async throws {
        let client = MockNetworkClient()
        client.result = .success(Self.geocodingJSON)
        let repository = GeocodingRepository(client: client, apiKey: "test-key")

        let results = try await repository.search(query: "São Paulo")

        #expect(results.count == 1)
        #expect(results[0].displayName == "São Paulo, Brazil")
        #expect(results[0].latitude == -23.5505)
    }

    @Test func filtersOutInvalidFeatures() async throws {
        let json = Data(
            """
            {
              "features": [
                { "properties": { "formatted": "Valid", "lat": 1, "lon": 2, "city": null, "country": null } },
                { "properties": { "formatted": null, "lat": 1, "lon": 2, "city": null, "country": null } }
              ]
            }
            """.utf8
        )
        let client = MockNetworkClient()
        client.result = .success(json)
        let repository = GeocodingRepository(client: client, apiKey: "test-key")

        let results = try await repository.search(query: "Test")

        #expect(results.count == 1)
        #expect(results[0].displayName == "Valid")
    }

    @Test func throwsDecodingErrorForInvalidJSON() async {
        let client = MockNetworkClient()
        client.result = .success(Data("{".utf8))
        let repository = GeocodingRepository(client: client, apiKey: "test-key")

        let error = await #expect(throws: NetworkError.self) {
            try await repository.search(query: "São Paulo")
        }
        if case .decoding = error { } else {
            Issue.record("Expected NetworkError.decoding")
        }
    }

    @Test func buildsExpectedRequestURL() async throws {
        let client = MockNetworkClient()
        client.result = .success(Self.geocodingJSON)
        let repository = GeocodingRepository(client: client, apiKey: "test-key")

        _ = try await repository.search(query: "São Paulo")

        let url = try #require(client.lastRequest?.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let query = Dictionary(uniqueKeysWithValues: (components.queryItems ?? []).map { ($0.name, $0.value) })

        #expect(url.host == "api.geoapify.com")
        #expect(query["text"] == "São Paulo")
        #expect(query["type"] == "city")
        #expect(query["limit"] == "5")
        #expect(query["apiKey"] == "test-key")
    }
}
