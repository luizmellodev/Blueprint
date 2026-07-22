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

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView("Loading place details…")
                    .accessibilityLabel("Loading place details")
            case .success(let poi):
                List {
                    Section {
                        Text(poi.name)
                            .font(DSTypography.title2)
                            .fontWeight(.semibold)
                    }

                    if let address = poi.address {
                        Section("Location") {
                            Text(address)
                        }
                    }

                    if let hours = poi.openingHours {
                        Section("Opening Hours") {
                            Text(hours)
                        }
                    }

                    if let phone = poi.phone {
                        Section("Contact") {
                            Text(phone)
                                .accessibilityLabel("Phone: \(phone)")
                        }
                    }

                    if let website = poi.website {
                        Section("Website") {
                            Link(website.absoluteString, destination: website)
                                .accessibilityLabel("Open website")
                                .accessibilityHint("Opens in Safari")
                        }
                    }
                }
            case .failure:
                Text("Something went wrong.")
                    .foregroundStyle(.secondary)
                    .accessibilityLabel("Failed to load place details.")
            }
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if viewModel.showFavoriteButton {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.toggleFavorite()
                    } label: {
                        Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                    }
                    .accessibilityLabel(viewModel.isFavorite ? "Remove from favorites" : "Add to favorites")
                    .accessibilityValue(viewModel.isFavorite ? "Saved" : "Not saved")
                }
            }
        }
    }
}
