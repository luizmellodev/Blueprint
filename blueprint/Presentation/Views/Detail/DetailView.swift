//
//  DetailView.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import DesignSystem
// TODO: Explicar porque não usamos tamanhos fixos de fonte (Dynamic Type)
// TODO: Explicar o padrão de placeholder inline para dados async (evita layout shift vs animação de entrada)
import SwiftUI

struct DetailView: View {
    @State var viewModel: DetailViewModel

    private var categoryColor: Color {
        guard case .success(let poi) = viewModel.state,
              let category = poi.categories.first else { return DSColor.unknown }
        switch category {
        case .tourism:       return DSColor.tourism
        case .catering:      return DSColor.catering
        case .entertainment: return DSColor.entertainment
        case .leisure:       return DSColor.leisure
        case .accommodation: return DSColor.accommodation
        default:             return DSColor.unknown
        }
    }

    private var categoryIcon: String {
        guard case .success(let poi) = viewModel.state,
              let category = poi.categories.first else { return "mappin" }
        switch category {
        case .tourism:       return "photo.on.rectangle"
        case .catering:      return "fork.knife"
        case .entertainment: return "music.note"
        case .leisure:       return "figure.walk"
        case .accommodation: return "bed.double"
        default:             return "mappin"
        }
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView("Loading place details…")
                    .accessibilityLabel("Loading place details")

            case .success(let poi):
                ScrollView {
                    VStack(spacing: DSSpacing.md) {
                        headerSection(poi)
                        POIMapView(poi: poi)
                        infoCard(poi)
                    }
                    .padding(.bottom, DSSpacing.xl)
                }
                .task {
                    await viewModel.loadDetails()
                }

            case .failure:
                VStack(spacing: DSSpacing.md) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary)
                        .accessibilityHidden(true)
                    Text("Something went wrong.")
                        .font(DSTypography.headline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle({
            if case .success(let poi) = viewModel.state { return poi.name }
            return "Detail"
        }())
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func headerSection(_ poi: POI) -> some View {
        VStack(spacing: DSSpacing.md) {
            ZStack {
                Circle()
                    .fill(categoryColor.opacity(0.15))
                    .frame(width: 80, height: 80)
                Image(systemName: categoryIcon)
                    .font(.system(size: 32))
                    .foregroundStyle(categoryColor)
            }
            .accessibilityHidden(true)

            VStack(spacing: DSSpacing.xs) {
                Text(poi.name)
                    .font(DSTypography.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                if let category = poi.categories.first {
                    Text(category.rawValue.capitalized)
                        .font(DSTypography.caption)
                        .foregroundStyle(categoryColor)
                        .padding(.horizontal, DSSpacing.sm)
                        .padding(.vertical, DSSpacing.xxs)
                        .background(categoryColor.opacity(0.12), in: Capsule())
                }

                if let city = poi.city {
                    Text(city)
                        .font(DSTypography.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            if viewModel.showFavoriteButton {
                AnimatedFavoriteButton(isLiked: viewModel.isFavorite) {
                    viewModel.toggleFavorite()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DSSpacing.xl)
        .padding(.horizontal, DSSpacing.lg)
        .background(categoryColor.opacity(0.06))
    }

    @ViewBuilder
    private func infoCard(_ poi: POI) -> some View {
        let details = viewModel.details
        let isLoading = details == nil

        VStack(spacing: 0) {
            let address = poi.address ?? details?.addressLine1
            if let address {
                DetailRowView(icon: "mappin.circle.fill", iconColor: .red, title: "Address", value: address)
                Divider().padding(.leading, 56)
            }

            if let hours = poi.openingHours {
                DetailRowView(icon: "clock.fill", iconColor: .orange, title: "Opening Hours", value: hours)
                Divider().padding(.leading, 56)
            }

            if let phone = poi.phone {
                DetailRowView(icon: "phone.fill", iconColor: .green, title: "Phone", value: phone)
                    .accessibilityLabel("Phone: \(phone)")
                Divider().padding(.leading, 56)
            }

            if let website = poi.website {
                Link(destination: website) {
                    DetailRowView(
                        icon: "safari.fill", iconColor: .blue,
                        title: "Website",
                        value: website.host() ?? website.absoluteString,
                        isLink: true
                    )
                }
                .foregroundStyle(.primary)
                Divider().padding(.leading, 56)
            }

            if isLoading {
                DetailRowPlaceholder()
                Divider().padding(.leading, 56)
                DetailRowPlaceholder()
            } else if let details {
                detailsRows(details)
            }
        }
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.lg))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        .padding(.horizontal, DSSpacing.md)
        .animation(.easeOut(duration: 0.2), value: isLoading)
    }

    @ViewBuilder
    private func detailsRows(_ details: PlaceDetails) -> some View {
        if let wheelchair = details.isWheelchairAccessible {
            DetailRowView(
                icon: wheelchair ? "figure.roll" : "figure.roll.runningpace",
                iconColor: wheelchair ? .green : .secondary,
                title: "Accessibility",
                value: wheelchair ? "Wheelchair accessible" : "Not wheelchair accessible"
            )
            Divider().padding(.leading, 56)
        }

        if let fee = details.fee {
            DetailRowView(
                icon: fee ? "creditcard.fill" : "gift.fill",
                iconColor: fee ? .orange : .green,
                title: "Admission",
                value: fee ? "Paid admission" : "Free admission"
            )
            Divider().padding(.leading, 56)
        }

        if let timezone = details.timezone {
            DetailRowView(icon: "clock.badge.fill", iconColor: .purple, title: "Timezone", value: timezone)
            Divider().padding(.leading, 56)
        }

        if let wikipedia = details.wikipediaURL {
            Link(destination: wikipedia) {
                DetailRowView(
                    icon: "book.fill", iconColor: .indigo,
                    title: "Wikipedia", value: "Open article",
                    isLink: true
                )
            }
            .foregroundStyle(.primary)
        }
    }
}

private struct PreviewFetchDetailsUseCase: FetchPlaceDetailsUseCaseProtocol {
    func execute(poiID: String) async throws -> PlaceDetails {
        PlaceDetails(
            poiID: poiID, wikipediaURL: nil, wikidataID: nil,
            isWheelchairAccessible: true, fee: false,
            timezone: "America/Sao_Paulo",
            addressLine1: "Parque da Independência", addressLine2: nil
        )
    }
}

@MainActor
private struct PreviewFavoritesUseCase: FavoritesUseCaseProtocol {
    func isFavorite(id: String) -> Bool { false }
    func toggle(_ poi: POI) throws {}
    func fetchAll() -> [POI] { [] }
}

private struct PreviewFeatureFlags: FeatureFlagServiceProtocol {
    func isEnabled(_ flag: FeatureFlag) -> Bool { true }
}

#Preview {
    NavigationStack {
        DetailView(viewModel: DetailViewModel(
            poi: .preview(),
            fetchPlaceDetails: PreviewFetchDetailsUseCase(),
            favorites: PreviewFavoritesUseCase(),
            featureFlags: PreviewFeatureFlags()
        ))
    }
}
