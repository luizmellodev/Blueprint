//
//  HomeView.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

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
                ProgressView()
            case .success(let pois):
                List(pois, id: \.id) { poi in
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
                }
            case .failure:
                Text("Something went wrong.")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Discover")
        .task {
            await viewModel.load()
        }
    }
}
