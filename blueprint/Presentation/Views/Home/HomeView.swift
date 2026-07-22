//
//  HomeView.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import CoreLocation
import DesignSystem
// TODO: Explicar as decisões de acessibilidade: accessibilityElement, labels compostos, ProgressView label
// TODO: Explicar o skeleton como substituto de ProgressView — feedback imediato sem layout shift
import SwiftUI

struct HomeView: View {
    @State var viewModel: HomeViewModel
    let router: any RouterProtocol
    let namespace: Namespace.ID

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

            case .success:
                ScrollView {
                    LazyVStack(spacing: DSSpacing.sm) {
                        ForEach(viewModel.visiblePOIs, id: \.id) { poi in
                            Button {
                                router.push(.detail(poi: poi))
                            } label: {
                                POICardView(poi: poi)
                            }
                            .buttonStyle(.plain)
                            .zoomSource(id: poi.id, namespace: namespace)
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
                            ProgressView("Loading more places")
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
                        .accessibilityHidden(true)
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

private struct PreviewFetchUseCase: FetchNearbyPOIsUseCaseProtocol {
    func execute(lat: Double, lon: Double, limit: Int, offset: Int) async throws -> PagedResult<POI> {
        PagedResult(items: (1...6).map { _ in .preview() }, hasMore: false)
    }
}

private struct PreviewSearchUseCase: SearchLocationUseCaseProtocol {
    func execute(query: String) async throws -> [GeocodingResult] { [] }
}

private final class PreviewLocationService: LocationServiceProtocol, @unchecked Sendable {
    func requestAuthorization() async -> LocationAuthorizationStatus { .authorized }
    func authorizationStatus() -> LocationAuthorizationStatus { .authorized }
    func getCurrentCoordinates() async throws -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333)
    }
}

#Preview {
    @Previewable @Namespace var namespace
    NavigationStack {
        HomeView(
            viewModel: HomeViewModel(
                fetchNearbyPOIs: PreviewFetchUseCase(),
                searchLocation: PreviewSearchUseCase(),
                locationService: PreviewLocationService()
            ),
            router: AppRouter(),
            namespace: namespace
        )
    }
}
