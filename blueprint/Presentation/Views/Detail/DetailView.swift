//
//  DetailView.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

// TODO: Explicar accessibilityValue no botão de favorito (estado atual lido pelo VoiceOver)
// TODO: Explicar porque não usamos tamanhos fixos de fonte (Dynamic Type)

import SwiftUI
import DesignSystem

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

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView("Loading place details…")
                    .accessibilityLabel("Loading place details")

            case .success(let poi):
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        headerSection(poi)
                        infoSection(poi)
                        if let details = viewModel.details {
                            detailsSection(details)
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                        }
                    }
                    .padding(.bottom, DSSpacing.xl)
                    .animation(.easeOut(duration: 0.3), value: viewModel.details != nil)
                }
                .task {
                    await viewModel.loadDetails()
                }

            case .failure:
                VStack(spacing: DSSpacing.md) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary)
                    Text("Something went wrong.")
                        .font(DSTypography.headline)
                        .foregroundStyle(.secondary)
                        .accessibilityLabel("Failed to load place details.")
                }
            }
        }
        .navigationTitle({
            if case .success(let poi) = viewModel.state { return poi.name }
            return "Detail"
        }())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if viewModel.showFavoriteButton {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.toggleFavorite()
                    } label: {
                        Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                            .symbolEffect(.bounce, value: viewModel.isFavorite)
                    }
                    .accessibilityLabel(viewModel.isFavorite ? "Remove from favorites" : "Add to favorites")
                    .accessibilityValue(viewModel.isFavorite ? "Saved" : "Not saved")
                }
            }
        }
    }

    @ViewBuilder
    private func headerSection(_ poi: POI) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            HStack {
                Text(poi.name)
                    .font(DSTypography.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                Spacer()
            }

            if let category = poi.categories.first {
                Text(category.rawValue.capitalized)
                    .font(DSTypography.caption)
                    .foregroundStyle(categoryColor)
                    .padding(.horizontal, DSSpacing.sm)
                    .padding(.vertical, DSSpacing.xxs)
                    .background(categoryColor.opacity(0.12), in: Capsule())
            }
        }
        .padding(DSSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(categoryColor.opacity(0.07))
    }

    @ViewBuilder
    private func infoSection(_ poi: POI) -> some View {
        VStack(spacing: 0) {
            if let address = poi.address {
                DetailRowView(icon: "mappin.circle.fill", iconColor: .red, title: "Location", value: address)
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
                    DetailRowView(icon: "safari.fill", iconColor: .blue, title: "Website", value: website.host() ?? website.absoluteString, isLink: true)
                }
                .foregroundStyle(.primary)
            }
        }
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.lg))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        .padding(.horizontal, DSSpacing.md)
        .padding(.top, DSSpacing.md)
    }

    @ViewBuilder
    private func detailsSection(_ details: PlaceDetails) -> some View {
        VStack(spacing: 0) {
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
                    DetailRowView(icon: "book.fill", iconColor: .indigo, title: "Wikipedia", value: "Open article", isLink: true)
                }
                .foregroundStyle(.primary)
            }
        }
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.lg))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        .padding(.horizontal, DSSpacing.md)
        .padding(.top, DSSpacing.sm)
    }
}
