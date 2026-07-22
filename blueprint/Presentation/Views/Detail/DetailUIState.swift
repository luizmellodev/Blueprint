//
//  DetailUIState.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

enum DetailUIState {
    case idle
    case loading
    case success(POI)
    case failure(AppError)
}
