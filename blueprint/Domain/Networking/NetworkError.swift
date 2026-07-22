//
//  NetworkError.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decoding
    case unknown(Error)
}
