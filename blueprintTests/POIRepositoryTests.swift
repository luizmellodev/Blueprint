//
//  POIRepositoryTests.swift
//  blueprintTests
//
//  Created by Luiz Mello on 24/07/26.
//

import Foundation
import Networking
import Testing
@testable import blueprint

@MainActor
struct POIRepositoryTests {

    private static let placesJSON = Data(
        """
        {
          "features": [{
            "properties": {
              "place_id": "abc123",
              "name": "Museu do Ipiranga",
              "categories": ["tourism.museum"],
              "formatted": "Parque da Independência, São Paulo",
              "city": "São Paulo",
              "country": "Brazil"
            },
            "geometry": { "coordinates": [-46.6333, -23.5505] }
          }]
        }
        """.utf8
    )

    @Test func returnsMappedPOIsFromNetwork() async throws {
        let client = MockNetworkClient()
        client.result = .success(Self.placesJSON)
        let repository = POIRepository(client: client, apiKey: "test-key")

        let pois = try await repository.fetchNearby(lat: 10.0, lon: 20.0, limit: 20, offset: 0)

        #expect(pois.count == 1)
        #expect(pois[0].id == "abc123")
        #expect(pois[0].name == "Museu do Ipiranga")
        #expect(client.callCount == 1)
    }

    @Test func returnsCachedResultWhenOffsetIsZero() async throws {
        let client = MockNetworkClient()
        client.result = .success(Self.placesJSON)
        let repository = POIRepository(client: client, apiKey: "test-key")

        _ = try await repository.fetchNearby(lat: 11.0, lon: 21.0, limit: 20, offset: 0)
        _ = try await repository.fetchNearby(lat: 11.0, lon: 21.0, limit: 20, offset: 0)

        #expect(client.callCount == 1)
    }

    @Test func skipsCacheWhenOffsetIsGreaterThanZero() async throws {
        let client = MockNetworkClient()
        client.result = .success(Self.placesJSON)
        let repository = POIRepository(client: client, apiKey: "test-key")

        _ = try await repository.fetchNearby(lat: 12.0, lon: 22.0, limit: 20, offset: 0)
        _ = try await repository.fetchNearby(lat: 12.0, lon: 22.0, limit: 20, offset: 20)

        #expect(client.callCount == 2)
    }

    @Test func throwsDecodingErrorForInvalidJSON() async {
        let client = MockNetworkClient()
        client.result = .success(Data("{".utf8))
        let repository = POIRepository(client: client, apiKey: "test-key")

        let error = await #expect(throws: NetworkError.self) {
            try await repository.fetchNearby(lat: 13.0, lon: 23.0, limit: 20, offset: 0)
        }
        if case .decoding = error { } else {
            Issue.record("Expected NetworkError.decoding")
        }
    }

    @Test func throwsWhenNetworkClientFails() async {
        struct TestError: Error {}
        let client = MockNetworkClient()
        client.result = .failure(TestError())
        let repository = POIRepository(client: client, apiKey: "test-key")

        await #expect(throws: TestError.self) {
            try await repository.fetchNearby(lat: 14.0, lon: 24.0, limit: 20, offset: 0)
        }
    }

    @Test func buildsExpectedRequestURL() async throws {
        let client = MockNetworkClient()
        client.result = .success(Self.placesJSON)
        let repository = POIRepository(client: client, apiKey: "test-key")

        _ = try await repository.fetchNearby(lat: 15.0, lon: 25.0, limit: 20, offset: 0)

        let url = try #require(client.lastRequest?.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let query = Dictionary(uniqueKeysWithValues: (components.queryItems ?? []).map { ($0.name, $0.value) })

        #expect(url.host == "api.geoapify.com")
        #expect(query["categories"] == "tourism,catering,entertainment,leisure")
        #expect(query["filter"] == "circle:25.0,15.0,5000")
        #expect(query["limit"] == "20")
        #expect(query["offset"] == "0")
        #expect(query["apiKey"] == "test-key")
    }
}
