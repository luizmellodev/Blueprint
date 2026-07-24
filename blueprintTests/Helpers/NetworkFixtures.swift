//
//  NetworkFixtures.swift
//  blueprintTests
//
//  Created by Luiz Mello on 24/07/26.
//

import Foundation

enum NetworkFixtures {
    static let placesResponse = """
    {
      "features": [{
        "properties": {
          "place_id": "place-1",
          "name": "Museum",
          "categories": ["tourism.museum"],
          "city": "São Paulo"
        },
        "geometry": { "coordinates": [-46.6333, -23.5505] }
      }]
    }
    """.data(using: .utf8)!

    static let geocodingResponse = """
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
    """.data(using: .utf8)!

    static let placeDetailsResponse = """
    {
      "features": [{
        "properties": {
          "place_id": "place-1",
          "address_line1": "Rua A, 100",
          "address_line2": "São Paulo",
          "fee": false,
          "facilities": { "wheelchair": true },
          "wiki_and_media": {
            "wikidata": "Q123",
            "wikipedia": "https://en.wikipedia.org/wiki/Test"
          },
          "timezone": { "name": "America/Sao_Paulo" }
        }
      }]
    }
    """.data(using: .utf8)!

    static let emptyFeaturesResponse = """
    { "features": [] }
    """.data(using: .utf8)!
}
