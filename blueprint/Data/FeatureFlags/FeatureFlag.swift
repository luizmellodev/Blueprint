//
//  FeatureFlag.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

// TODO: Explicar porque FeatureFlag é um enum e não strings soltas (type-safety, autocomplete, sem typos)

enum FeatureFlag: String {
    case favorites
    case mapView
    case categoryFilter
}
