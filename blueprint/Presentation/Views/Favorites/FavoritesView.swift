//
//  FavoritesView.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import DesignSystem
import SwiftUI

struct FavoritesView: View {
    @State var viewModel: FavoritesViewModel
    let router: any RouterProtocol

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle:
                Color.clear

            case .empty:
                ContentUnavailableView(
                    "No favorites yet",
                    systemImage: "heart",
                    description: Text("Places you save on Detail appear here.")
                )

            case .success:
                List {
                    ForEach(viewModel.pois, id: \.id) { poi in
                        Button {
                            router.push(.detail(poi: poi))
                        } label: {
                            POICardView(poi: poi)
                        }
                        .buttonStyle(.plain)
                        .listRowInsets(EdgeInsets(
                            top: DSSpacing.xs,
                            leading: DSSpacing.md,
                            bottom: DSSpacing.xs,
                            trailing: DSSpacing.md
                        ))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel(accessibilityLabel(for: poi))
                        .accessibilityHint("Double tap to see details")
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                viewModel.remove(poi)
                            } label: {
                                Label("Remove", systemImage: "heart.slash")
                            }
                        }
                    }
                }
                .listStyle(.plain)

            case .failure:
                VStack(spacing: DSSpacing.md) {
                    Image(systemName: "heart.slash")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary)
                        .accessibilityHidden(true)
                    Text("Could not load favorites.")
                        .font(DSTypography.headline)
                        .foregroundStyle(.secondary)
                    Button("Try again") {
                        viewModel.load()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .navigationTitle("Favorites")
        .onAppear {
            viewModel.load()
        }
    }

    private func accessibilityLabel(for poi: POI) -> String {
        if let city = poi.city {
            return "\(poi.name), \(city)"
        }
        return poi.name
    }
}

private struct PreviewFavoritesUseCase: FavoritesUseCaseProtocol {
    func isFavorite(id: String) -> Bool { false }
    func toggle(_ poi: POI) throws {}
    func fetchAll() -> [POI] { [.preview()] }
}

#Preview {
    NavigationStack {
        FavoritesView(
            viewModel: FavoritesViewModel(favorites: PreviewFavoritesUseCase()),
            router: AppRouter()
        )
    }
}
