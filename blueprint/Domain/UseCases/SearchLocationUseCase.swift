//
//  SearchLocationUseCase.swift
//  blueprint
//
//  Created by Luiz Mello on 22/07/26.
//

import Foundation

struct SearchLocationUseCase: SearchLocationUseCaseProtocol {
    private let repository: GeocodingRepositoryProtocol

    init(repository: GeocodingRepositoryProtocol) {
        self.repository = repository
    }

    func execute(query: String) async throws -> [GeocodingResult] {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return [] }
        return try await repository.search(query: trimmed)
    }
}
