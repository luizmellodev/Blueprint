//
//  LocationServiceError.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

enum LocationServiceError: Error, Sendable {
    case notAuthorized
    case failedToGetLocation
}
