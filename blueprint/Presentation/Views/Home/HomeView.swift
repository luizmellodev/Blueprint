//
//  HomeView.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

// TODO: Explicar as decisões de acessibilidade: accessibilityElement, labels compostos, ProgressView label

import SwiftUI

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
                        VStack(alignment: .leading, spacing: 4) {
                            Text(poi.name)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            if let city = poi.city {
                                Text(city)
                                    .font(.subheadline)
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
                VStack(spacing: 16) {
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
