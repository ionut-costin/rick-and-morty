//
//  CharacterFilterViewModel.swift
//  Rick&Morty
//
//  Created by Ionut Andrei COSTIN on 27.04.2023.
//

import Foundation
import Combine
import SwiftUI
import RickMortySwiftApi

class CharacterFilterViewModel: ObservableObject {

    private let filterSubject: CurrentValueSubject<RMCharacterFilter, Never>

    @Published var status: Status = .none
    @Published var gender: Gender = .none
    @Published var species: String = ""

    let statuses: [Status] = [Status.none, .alive, .dead]
    let genders: [Gender] = [Gender.none, .male, .female, .genderless]

    init(filterSubject: CurrentValueSubject<RMCharacterFilter, Never>) {
        self.filterSubject = filterSubject

        let filter = filterSubject.value
        self.status = Status(rawValue: filter.status) ?? .none
        self.gender = Gender(rawValue: filter.gender) ?? .none
        self.species = filter.species
    }

    func updateFilter() {
        let filter = RMCharacterFilter(status: status, species: species, gender: gender)
        filterSubject.send(filter)
    }
}
