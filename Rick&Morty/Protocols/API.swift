//
//  API.swift
//  Rick&Morty
//
//  Created by Ionut Andrei COSTIN on 27.04.2023.
//

import Foundation
import RickMortySwiftApi

protocol API {
    func fetchCharacters(filter: RMCharacterFilter) async throws -> [RMCharacterModel]
}
