//
//  RMCharacterFilter+Extensions.swift
//  Rick&Morty
//
//  Created by Ionut Andrei COSTIN on 27.04.2023.
//

import Foundation
import RickMortySwiftApi

extension RMCharacterFilter {
    public init(name: String = "", status: Status = .none, species: String = "", type: String = "", gender: Gender = .none) {
        var query = ""
        let parameterDict = ["name" : name,
                             "status" : status.rawValue,
                             "species" : species,
                             "type" : type,
                             "gender" : gender.rawValue]
            .filter { !$0.value.isEmpty }
        if !parameterDict.isEmpty {
            query = "character/?"
            parameterDict.forEach { key, value in
                query.append(key + "=" + value + "&")
            }
        }

        self.init(name: name, status: status.rawValue, species: species, type: type, gender: gender.rawValue, query: query)
    }
}
