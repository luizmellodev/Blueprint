//
//  DetailFactory.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import SwiftUI

@MainActor
final class DetailFactory {
    func makeView(poi: POI) -> some View {
        let viewModel = DetailViewModel(poi: poi)
        return DetailView(viewModel: viewModel)
    }
}
