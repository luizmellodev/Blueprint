//
//  POI+Filtering.swift
//  blueprint
//
//  Created by Luiz Mello on 29/07/26.
//

import Foundation

extension POI {
    func matches(query: String) -> Bool {
        guard !query.isEmpty else { return true }
        let lowercased = query.lowercased()
        return name.lowercased().contains(lowercased) ||
               city?.lowercased().contains(lowercased) == true
    }
}

extension Array where Element == POI {
    func filtered(by query: String) -> [POI] {
        guard !query.isEmpty else { return self }
        return filter { $0.matches(query: query) }
    }
}
