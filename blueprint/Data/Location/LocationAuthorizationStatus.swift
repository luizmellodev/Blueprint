//
//  LocationAuthorizationStatus.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

enum LocationAuthorizationStatus: Sendable {
    case notDetermined
    case authorized
    case denied
    case restricted
}
