//
//  POICardView.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import DesignSystem
import SwiftUI

struct POICardView: View {
    let poi: POI

    private var category: PlaceCategory {
        poi.categories.first ?? .unknown
    }

    private var categoryColor: Color {
        switch category {
        case .tourism:       DSColor.tourism
        case .catering:      DSColor.catering
        case .entertainment: DSColor.entertainment
        case .leisure:       DSColor.leisure
        case .accommodation: DSColor.accommodation
        default:             DSColor.unknown
        }
    }

    private var categoryIcon: String {
        switch category {
        case .tourism:       "photo.on.rectangle"
        case .catering:      "fork.knife"
        case .entertainment: "music.note"
        case .leisure:       "figure.walk"
        case .accommodation: "bed.double"
        default:             "mappin"
        }
    }

    var body: some View {
        HStack(spacing: DSSpacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: DSRadius.sm)
                    .fill(categoryColor.opacity(0.15))
                    .frame(width: 48, height: 48)
                Image(systemName: categoryIcon)
                    .font(.system(size: 20))
                    .foregroundStyle(categoryColor)
            }

            VStack(alignment: .leading, spacing: DSSpacing.xxs) {
                Text(poi.name)
                    .font(DSTypography.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)

                if let city = poi.city {
                    Text(city)
                        .font(DSTypography.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text(category.rawValue.capitalized)
                    .font(DSTypography.caption)
                    .foregroundStyle(categoryColor)
                    .padding(.horizontal, DSSpacing.xs)
                    .padding(.vertical, 2)
                    .background(categoryColor.opacity(0.1), in: Capsule())
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(DSSpacing.md)
        .background(.background, in: RoundedRectangle(cornerRadius: DSRadius.md))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    VStack(spacing: 12) {
        POICardView(poi: .preview())
        POICardView(poi: POI(
            id: "2", name: "Bar do João", categories: [.catering],
            latitude: -23.55, longitude: -46.63,
            address: "Rua das Flores, 42", city: "São Paulo",
            country: "Brazil", openingHours: nil, website: nil, phone: nil
        ))
    }
    .padding()
}
