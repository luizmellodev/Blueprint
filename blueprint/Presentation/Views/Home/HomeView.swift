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
            case .success(_):
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
                    .onAppear {
                        if poi.id == viewModel.visiblePOIs.last?.id {
                            Task { await viewModel.loadMore() }
                        }
                    }
                }
                .refreshable {
                    await viewModel.refresh()
                }
                if viewModel.isLoadingMore {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    LocationSearchView(viewModel: viewModel)
                } label: {
                    Label("Search location", systemImage: "magnifyingglass.circle")
                }
            }
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
