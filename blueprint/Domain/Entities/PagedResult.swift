//
//  PagedResult.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

struct PagedResult<T: Sendable>: Sendable {
    let items: [T]
    let hasMore: Bool
}
