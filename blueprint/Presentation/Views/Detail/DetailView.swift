//
//  DetailView.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import SwiftUI

struct DetailView: View {
    @State var viewModel: DetailViewModel

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .success(let poi):
                List {
                    Section {
                        Text(poi.name)
                            .font(.title2)
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
                        }
                    }

                    if let website = poi.website {
                        Section("Website") {
                            Link(website.absoluteString, destination: website)
                        }
                    }
                }
            case .failure:
                Text("Something went wrong.")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.toggleFavorite()
                } label: {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                }
            }
        }
    }
}
