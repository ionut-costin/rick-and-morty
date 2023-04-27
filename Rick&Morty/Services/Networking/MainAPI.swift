//
//  MainAPI.swift
//  Rick&Morty
//
//  Created by Ionut Andrei COSTIN on 27.04.2023.
//

import Foundation
import RickMortySwiftApi

class MainAPI: API {
    private let rmClient = RMClient()

    func fetchCharacters(filter: RMCharacterFilter) async throws -> [RMCharacterModel] {
        if filter.query.isEmpty {
            return try await rmClient.character().getAllCharacters()
        } else {
            return try await rmClient.character().getCharactersByFilter(filter: filter)
        }
    }
}
