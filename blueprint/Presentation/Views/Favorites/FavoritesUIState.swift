//
//  FavoritesUIState.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

enum FavoritesUIState: Equatable {
    case idle
    case empty
    case success
    case failure(AppError)
}
