//
//  ZoomTransitionModifier.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

// TODO: Explicar o padrão de ViewModifier para isolar APIs específicas de versão de OS

import SwiftUI

struct ZoomSource: ViewModifier {
    let id: String
    let namespace: Namespace.ID

    func body(content: Content) -> some View {
        if #available(iOS 18.0, *) {
            content.matchedTransitionSource(id: id, in: namespace)
        } else {
            content
        }
    }
}

struct ZoomDestination: ViewModifier {
    let id: String
    let namespace: Namespace.ID

    func body(content: Content) -> some View {
        if #available(iOS 18.0, *) {
            content.navigationTransition(.zoom(sourceID: id, in: namespace))
        } else {
            content
        }
    }
}

extension View {
    func zoomSource(id: String, namespace: Namespace.ID) -> some View {
        modifier(ZoomSource(id: id, namespace: namespace))
    }

    func zoomDestination(id: String, namespace: Namespace.ID) -> some View {
        modifier(ZoomDestination(id: id, namespace: namespace))
    }
}
