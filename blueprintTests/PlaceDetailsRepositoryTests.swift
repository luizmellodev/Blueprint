//
//  PlaceDetailsRepositoryTests.swift
//  blueprintTests
//
//  Created by Luiz Mello on 24/07/26.
//

import Foundation
import Networking
import Testing
@testable import blueprint

@MainActor
struct PlaceDetailsRepositoryTests {

    private static let detailsJSON = Data(
        """
        {
          "features": [{
            "properties": {
              "place_id": "abc123",
              "address_line1": "Rua Mock, 123",
              "address_line2": "São Paulo, SP",
              "fee": true,
              "facilities": { "wheelchair": true },
              "wiki_and_media": {
                "wikidata": "Q123",
                "wikipedia": "https://en.wikipedia.org/wiki/Test"
              },
              "timezone": { "name": "America/Sao_Paulo" }
            }
          }]
        }
        """.utf8
    )

    @Test func returnsMappedPlaceDetails() async throws {
        let client = MockNetworkClient()
        client.result = .success(Self.detailsJSON)
        let repository = PlaceDetailsRepository(client: client, apiKey: "test-key")

        let details = try await repository.fetchDetails(for: "abc123")

        #expect(details.poiID == "abc123")
        #expect(details.addressLine1 == "Rua Mock, 123")
        #expect(details.fee == true)
        #expect(details.isWheelchairAccessible == true)
    }

    @Test func throwsInvalidResponseWhenFeaturesAreEmpty() async {
        let client = MockNetworkClient()
        client.result = .success(Data("{\"features\": []}".utf8))
        let repository = PlaceDetailsRepository(client: client, apiKey: "test-key")

        let error = await #expect(throws: NetworkError.self) {
            try await repository.fetchDetails(for: "abc123")
        }
        if case .invalidResponse = error { } else {
            Issue.record("Expected NetworkError.invalidResponse")
        }
    }

    @Test func throwsDecodingErrorForInvalidJSON() async {
        let client = MockNetworkClient()
        client.result = .success(Data("{".utf8))
        let repository = PlaceDetailsRepository(client: client, apiKey: "test-key")

        let error = await #expect(throws: NetworkError.self) {
            try await repository.fetchDetails(for: "abc123")
        }
        if case .decoding = error { } else {
            Issue.record("Expected NetworkError.decoding")
        }
    }

    @Test func buildsExpectedRequestURL() async throws {
        let client = MockNetworkClient()
        client.result = .success(Self.detailsJSON)
        let repository = PlaceDetailsRepository(client: client, apiKey: "test-key")

        _ = try await repository.fetchDetails(for: "abc123")

        let url = try #require(client.lastRequest?.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let query = Dictionary(uniqueKeysWithValues: (components.queryItems ?? []).map { ($0.name, $0.value) })

        #expect(url.host == "api.geoapify.com")
        #expect(query["id"] == "abc123")
        #expect(query["apiKey"] == "test-key")
    }
}
