//
//  LocationSearchView.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import SwiftUI
import DesignSystem

struct LocationSearchView: View {
    @State var viewModel: HomeViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Section {
                HStack {
                    TextField("Search for a city…", text: $viewModel.locationQuery)
                        .textFieldStyle(.plain)
                        .autocorrectionDisabled()
                        .onChange(of: viewModel.locationQuery) {
                            viewModel.onLocationQueryChanged()
                        }
                    if !viewModel.locationQuery.isEmpty {
                        Button {
                            viewModel.clearLocationSearch()
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            if viewModel.isSearchingLocation {
                Section {
                    ProgressView("Searching…")
                        .frame(maxWidth: .infinity)
                }
            } else if !viewModel.locationSuggestions.isEmpty {
                Section("Results") {
                    ForEach(viewModel.locationSuggestions, id: \.self) { result in
                        Button {
                            Task {
                                await viewModel.selectLocation(result)
                                dismiss()
                            }
                        } label: {
                            VStack(alignment: .leading, spacing: DSSpacing.xxs) {
                                Text(result.displayName)
                                    .font(DSTypography.headline)
                                    .foregroundStyle(.primary)
                                if let country = result.country {
                                    Text(country)
                                        .font(DSTypography.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel(result.displayName)
                        .accessibilityHint("Double tap to load places in this location")
                    }
                }
            } else if !viewModel.locationQuery.isEmpty {
                Section {
                    Text("No results found.")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("Change Location")
        .navigationBarTitleDisplayMode(.inline)
    }
}
