//
//  POIValidationTests.swift
//  blueprintTests
//
//  Created by Luiz Mello on 29/07/26.
//

import Testing
@testable import blueprint

struct POIValidationTests {
    
    @Test func validPOIIsCreated() throws {
        let poi = try POI(
            id: "valid-id",
            name: "Valid Name",
            latitude: -23.5505,
            longitude: -46.6333
        )
        
        #expect(poi.id == "valid-id")
        #expect(poi.name == "Valid Name")
        #expect(poi.latitude == -23.5505)
        #expect(poi.longitude == -46.6333)
    }
    
    @Test func throwsErrorForEmptyID() {
        #expect(throws: ValidationError.emptyID) {
            try POI(
                id: "",
                name: "Valid Name",
                latitude: 0,
                longitude: 0
            )
        }
    }
    
    @Test func throwsErrorForEmptyName() {
        #expect(throws: ValidationError.emptyName) {
            try POI(
                id: "valid-id",
                name: "",
                latitude: 0,
                longitude: 0
            )
        }
    }
    
    @Test func throwsErrorForInvalidLatitude() {
        #expect(throws: ValidationError.invalidLatitude) {
            try POI(
                id: "valid-id",
                name: "Valid Name",
                latitude: 91,
                longitude: 0
            )
        }
    }
    
    @Test func throwsErrorForNegativeInvalidLatitude() {
        #expect(throws: ValidationError.invalidLatitude) {
            try POI(
                id: "valid-id",
                name: "Valid Name",
                latitude: -91,
                longitude: 0
            )
        }
    }
    
    @Test func throwsErrorForInvalidLongitude() {
        #expect(throws: ValidationError.invalidLongitude) {
            try POI(
                id: "valid-id",
                name: "Valid Name",
                latitude: 0,
                longitude: 181
            )
        }
    }
    
    @Test func throwsErrorForNegativeInvalidLongitude() {
        #expect(throws: ValidationError.invalidLongitude) {
            try POI(
                id: "valid-id",
                name: "Valid Name",
                latitude: 0,
                longitude: -181
            )
        }
    }
    
    @Test func acceptsValidBoundaryLatitude() throws {
        let poi1 = try POI(id: "1", name: "North", latitude: 90, longitude: 0)
        let poi2 = try POI(id: "2", name: "South", latitude: -90, longitude: 0)
        
        #expect(poi1.latitude == 90)
        #expect(poi2.latitude == -90)
    }
    
    @Test func acceptsValidBoundaryLongitude() throws {
        let poi1 = try POI(id: "1", name: "East", latitude: 0, longitude: 180)
        let poi2 = try POI(id: "2", name: "West", latitude: 0, longitude: -180)
        
        #expect(poi1.longitude == 180)
        #expect(poi2.longitude == -180)
    }
}
