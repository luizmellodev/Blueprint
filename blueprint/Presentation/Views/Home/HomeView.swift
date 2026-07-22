//
//  HomeView.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

// TODO: Explicar as decisões de acessibilidade: accessibilityElement, labels compostos, ProgressView label

import SwiftUI
import DesignSystem

struct HomeView: View {
    @State var viewModel: HomeViewModel
    let router: any RouterProtocol

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle:
                Color.clear
            case .loading:
                ProgressView("Loading nearby places…")
                    .accessibilityLabel("Loading nearby places")
            case .success(let pois):
                List(viewModel.visiblePOIs, id: \.id) { poi in
                    Button {
                        router.push(.detail(poi: poi))
                    } label: {
                        VStack(alignment: .leading, spacing: DSSpacing.xxs) {
                            Text(poi.name)
                                .font(DSTypography.headline)
                                .foregroundStyle(.primary)
                            if let city = poi.city {
                                Text(city)
                                    .font(DSTypography.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(accessibilityLabel(for: poi))
                    .accessibilityHint("Double tap to see details")
                }
                .refreshable {
                    await viewModel.refresh()
                }
            case .failure:
                VStack(spacing: DSSpacing.md) {
                    Text("Something went wrong.")
                        .foregroundStyle(.secondary)
                        .accessibilityLabel("Failed to load places.")
                    Button("Try again") {
                        viewModel.retry()
                    }
                }
            }
        }
        .navigationTitle("Discover")
        .searchable(text: $viewModel.searchQuery, prompt: "Search places")
        .onChange(of: viewModel.searchQuery) {
            viewModel.onSearchQueryChanged()
        }
        .task {
            await viewModel.load()
        }
    }

    private func accessibilityLabel(for poi: POI) -> String {
        if let city = poi.city {
            return "\(poi.name), \(city)"
        }
        return poi.name
    }
}
