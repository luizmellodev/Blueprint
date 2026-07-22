//
//  PlaceCategory.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

// TODO: Explicar porque PlaceCategory é um enum e não [String] (type-safety, documentação dos valores possíveis)

import Foundation

enum PlaceCategory: String, Codable, Sendable, CaseIterable {
    case tourism
    case catering
    case entertainment
    case leisure
    case accommodation
    case commercial
    case heritage
    case natural
    case unknown

    init(rawValue: String) {
        switch rawValue.split(separator: ".").first.map(String.init) {
        case "tourism": self = .tourism
        case "catering": self = .catering
        case "entertainment": self = .entertainment
        case "leisure": self = .leisure
        case "accommodation": self = .accommodation
        case "commercial": self = .commercial
        case "heritage": self = .heritage
        case "natural": self = .natural
        default: self = .unknown
        }
    }
}
