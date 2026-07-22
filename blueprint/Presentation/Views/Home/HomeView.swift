//
//  HomeView.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

// TODO: Explicar as decisões de acessibilidade: accessibilityElement, labels compostos, ProgressView label
// TODO: Explicar o skeleton como substituto de ProgressView — feedback imediato sem layout shift

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
                ScrollView {
                    LazyVStack(spacing: DSSpacing.sm) {
                        ForEach(0..<6, id: \.self) { _ in
                            SkeletonCardView()
                        }
                    }
                    .padding(.horizontal, DSSpacing.md)
                    .padding(.top, DSSpacing.sm)
                }

            case .success(_):
                ScrollView {
                    LazyVStack(spacing: DSSpacing.sm) {
                        ForEach(viewModel.visiblePOIs, id: \.id) { poi in
                            Button {
                                router.push(.detail(poi: poi))
                            } label: {
                                POICardView(poi: poi)
                            }
                            .buttonStyle(.plain)
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel(accessibilityLabel(for: poi))
                            .accessibilityHint("Double tap to see details")
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                            .onAppear {
                                if poi.id == viewModel.visiblePOIs.last?.id {
                                    Task { await viewModel.loadMore() }
                                }
                            }
                        }

                        if viewModel.isLoadingMore {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding(DSSpacing.md)
                        }
                    }
                    .padding(.horizontal, DSSpacing.md)
                    .padding(.top, DSSpacing.sm)
                    .animation(.easeOut(duration: 0.3), value: viewModel.visiblePOIs.count)
                }
                .refreshable {
                    await viewModel.refresh()
                }

            case .failure:
                VStack(spacing: DSSpacing.md) {
                    Image(systemName: "wifi.exclamationmark")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary)
                    Text("Something went wrong.")
                        .font(DSTypography.headline)
                        .foregroundStyle(.secondary)
                        .accessibilityLabel("Failed to load places.")
                    Button("Try again") {
                        viewModel.retry()
                    }
                    .buttonStyle(.borderedProminent)
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
