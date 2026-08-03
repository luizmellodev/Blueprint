//
//  POIBehaviorTests.swift
//  blueprintTests
//
//  Created by Luiz Mello on 29/07/26.
//

import CoreLocation
import Testing
@testable import blueprint

struct POIBehaviorTests {
    
    @Test func coordinateReturnsCorrectCLLocationCoordinate2D() throws {
        let poi = try POI(
            id: "test",
            name: "Test POI",
            latitude: -23.5505,
            longitude: -46.6333
        )
        
        let coordinate = poi.coordinate
        #expect(coordinate.latitude == -23.5505)
        #expect(coordinate.longitude == -46.6333)
    }
    
    @Test func isValidCoordinateReturnsTrueForValidCoordinates() throws {
        let poi = try POI(
            id: "test",
            name: "Test POI",
            latitude: -23.5505,
            longitude: -46.6333
        )
        
        #expect(poi.isValidCoordinate == true)
    }
    
    @Test func formattedAddressReturnsEmptyStringWhenAllFieldsAreNil() throws {
        let poi = try POI(
            id: "test",
            name: "Test POI",
            latitude: 0,
            longitude: 0
        )
        
        #expect(poi.formattedAddress == "")
    }
    
    @Test func formattedAddressJoinsAllAvailableFields() throws {
        let poi = try POI(
            id: "test",
            name: "Test POI",
            latitude: 0,
            longitude: 0,
            address: "Rua ABC",
            city: "São Paulo",
            country: "Brazil"
        )
        
        #expect(poi.formattedAddress == "Rua ABC, São Paulo, Brazil")
    }
    
    @Test func formattedAddressJoinsPartialFields() throws {
        let poi = try POI(
            id: "test",
            name: "Test POI",
            latitude: 0,
            longitude: 0,
            city: "São Paulo",
            country: "Brazil"
        )
        
        #expect(poi.formattedAddress == "São Paulo, Brazil")
    }
    
    @Test func displayCategoriesReturnsCapitalizedCategoryNames() throws {
        let poi = try POI(
            id: "test",
            name: "Test POI",
            categories: [.tourism, .heritage],
            latitude: 0,
            longitude: 0
        )
        
        #expect(poi.displayCategories == "Tourism, Heritage")
    }
    
    @Test func displayCategoriesReturnsEmptyStringForEmptyCategories() throws {
        let poi = try POI(
            id: "test",
            name: "Test POI",
            categories: [],
            latitude: 0,
            longitude: 0
        )
        
        #expect(poi.displayCategories == "")
    }
    
    @Test func matchesReturnsTrueForMatchingName() throws {
        let poi = POI.mock(name: "Museu do Ipiranga")
        
        #expect(poi.matches(query: "museu") == true)
        #expect(poi.matches(query: "MUSEU") == true)
        #expect(poi.matches(query: "Ipiranga") == true)
    }
    
    @Test func matchesReturnsTrueForMatchingCity() throws {
        let poi = POI.mock(city: "São Paulo")
        
        #expect(poi.matches(query: "são") == true)
        #expect(poi.matches(query: "PAULO") == true)
    }
    
    @Test func matchesReturnsFalseForNonMatchingQuery() throws {
        let poi = POI.mock(name: "Museu do Ipiranga", city: "São Paulo")
        
        #expect(poi.matches(query: "London") == false)
        #expect(poi.matches(query: "xyz") == false)
    }
    
    @Test func matchesReturnsTrueForEmptyQuery() throws {
        let poi = POI.mock()
        
        #expect(poi.matches(query: "") == true)
    }
    
    @Test func distanceCalculatesCorrectDistance() throws {
        let poi = try POI(
            id: "test",
            name: "Test POI",
            latitude: -23.5505,
            longitude: -46.6333
        )
        
        let userLocation = CLLocation(latitude: -23.5856, longitude: -46.6056)
        let distance = poi.distance(from: userLocation)
        
        #expect(distance > 0)
        #expect(distance < 10000)
    }
    
    @Test func arrayFilteredByEmptyQueryReturnsAll() {
        let pois = [
            POI.mock(id: "1", name: "Museu"),
            POI.mock(id: "2", name: "Parque"),
            POI.mock(id: "3", name: "Restaurante")
        ]
        
        let filtered = pois.filtered(by: "")
        #expect(filtered.count == 3)
    }
    
    @Test func arrayFilteredByQueryReturnsMatches() {
        let pois = [
            POI.mock(id: "1", name: "Museu do Ipiranga"),
            POI.mock(id: "2", name: "Parque Ibirapuera"),
            POI.mock(id: "3", name: "Restaurante Fasano")
        ]
        
        let filtered = pois.filtered(by: "museu")
        #expect(filtered.count == 1)
        #expect(filtered.first?.id == "1")
    }
    
    @Test func arrayFilteredByQueryIsCaseInsensitive() {
        let pois = [
            POI.mock(id: "1", name: "Museu do Ipiranga"),
            POI.mock(id: "2", name: "Parque Ibirapuera")
        ]
        
        let filtered = pois.filtered(by: "MUSEU")
        #expect(filtered.count == 1)
        #expect(filtered.first?.id == "1")
    }
    
    @Test func arrayFilteredMatchesCity() {
        let pois = [
            POI.mock(id: "1", name: "Place A", city: "São Paulo"),
            POI.mock(id: "2", name: "Place B", city: "Rio de Janeiro")
        ]
        
        let filtered = pois.filtered(by: "rio")
        #expect(filtered.count == 1)
        #expect(filtered.first?.id == "2")
    }
}
