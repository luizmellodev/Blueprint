//
//  POIMapView.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import DesignSystem
import MapKit
import SwiftUI

struct POIMapView: View {
    let poi: POI

    private var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: poi.latitude, longitude: poi.longitude)
    }

    var body: some View {
        Map(initialPosition: .camera(
            MapCamera(centerCoordinate: coordinate, distance: 600)
        )) {
            Marker(poi.name, coordinate: coordinate)
                .tint(.red)
        }
        .frame(height: 180)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.lg))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        .allowsHitTesting(false)
        .overlay(alignment: .bottomTrailing) {
            Button {
                openInMaps()
            } label: {
                Label("Open in Maps", systemImage: "arrow.triangle.turn.up.right.circle.fill")
                    .font(DSTypography.footnote)
                    .fontWeight(.medium)
                    .padding(.horizontal, DSSpacing.sm)
                    .padding(.vertical, DSSpacing.xs)
                    .background(.regularMaterial, in: Capsule())
            }
            .tint(.primary)
            .padding(DSSpacing.sm)
        }
        .padding(.horizontal, DSSpacing.md)
    }

    private func openInMaps() {
        let item = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        item.name = poi.name
        item.openInMaps()
    }
}
