//
//  ValidationError.swift
//  blueprint
//
//  Created by Luiz Mello on 29/07/26.
//

import Foundation

enum ValidationError: Error, Equatable {
    case emptyID
    case emptyName
    case invalidLatitude
    case invalidLongitude
}
