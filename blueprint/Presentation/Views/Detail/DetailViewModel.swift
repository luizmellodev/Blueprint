//
//  DetailViewModel.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

@MainActor
@Observable
final class DetailViewModel {
    private(set) var state: DetailUIState

    init(poi: POI) {
        self.state = .success(poi)
    }
}
