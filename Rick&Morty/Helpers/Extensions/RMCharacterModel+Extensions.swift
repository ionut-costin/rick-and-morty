//
//  RMCharacterModel+Extensions.swift
//  Rick&Morty
//
//  Created by Ionut Andrei COSTIN on 27.04.2023.
//

import RickMortySwiftApi

extension RMCharacterModel: Hashable {
    public static func == (lhs: RickMortySwiftApi.RMCharacterModel, rhs: RickMortySwiftApi.RMCharacterModel) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
