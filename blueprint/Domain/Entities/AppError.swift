//
//  AppError.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

enum AppError: Error, Equatable {
    case networking
    case decoding
    case invalidURL
    case unknown
}
