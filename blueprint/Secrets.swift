//
//  Secrets.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

// TODO: Explicar porque lemos do Bundle (via xcconfig → Info.plist) em vez de hardcodar a chave

import Foundation

enum Secrets {
    static var geoapifyAPIKey: String {
        Bundle.main.infoDictionary?["GeoapifyAPIKey"] as? String ?? ""
    }
}
