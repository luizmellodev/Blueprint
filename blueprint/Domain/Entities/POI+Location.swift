//
//  POI+Location.swift
//  blueprint
//
//  Created by Luiz Mello on 29/07/26.
//

import CoreLocation

extension POI {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var isValidCoordinate: Bool {
        (-90...90).contains(latitude) && (-180...180).contains(longitude)
    }
    
    func distance(from location: CLLocation) -> CLLocationDistance {
        let poiLocation = CLLocation(latitude: latitude, longitude: longitude)
        return location.distance(from: poiLocation)
    }
}
