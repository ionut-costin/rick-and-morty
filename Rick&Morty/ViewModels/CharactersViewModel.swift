//
//  CharactersViewModel.swift
//  Rick&Morty
//
//  Created by Ionut Andrei COSTIN on 27.04.2023.
//

import Foundation
import SwiftUI
import Combine
import RickMortySwiftApi

class CharactersViewModel: ObservableObject {
    private let api: API
    private let filterSubject: CurrentValueSubject<RMCharacterFilter, Never>
    private let characterSelectedSubject: PassthroughSubject<RMCharacterModel, Never>

    private var subscriptions: [AnyCancellable] = []

    @Published var isLoading = false
    @Published var search: String = ""
    @Published public var characters: [RMCharacterModel] = []
    @Published var error: Error?

    var characterSelected: RMCharacterModel? {
        didSet {
            guard let characterSelected = characterSelected else { return }
            characterSelectedSubject.send(characterSelected)
        }
    }

    init(api: API,
         filterSubject: CurrentValueSubject<RMCharacterFilter, Never>,
         characterSelectedSubject: PassthroughSubject<RMCharacterModel, Never>) {
        self.api = api
        self.filterSubject = filterSubject
        self.characterSelectedSubject = characterSelectedSubject

        setSubscribers()
    }

    private func setSubscribers() {
        $search
            .dropFirst()
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { search in
                let currentFilter = self.filterSubject.value
                let newFilter = RMCharacterFilter(name: search.trimmingCharacters(in: .whitespacesAndNewlines),
                                                  status: Status(rawValue: currentFilter.status) ?? .none,
                                                  species: currentFilter.species,
                                                  type: currentFilter.type,
                                                  gender: Gender(rawValue: currentFilter.gender) ?? .none)
                self.filterSubject.send(newFilter)
            }
            .store(in: &subscriptions)

        filterSubject
            .dropFirst()
            .sink { filter in
                self.fetchCharacters(filter: filter)
            }
            .store(in: &subscriptions)
    }

    public func fetchCharacters(filter: RMCharacterFilter = RMCharacterFilter()) {
        isLoading = true
        Task { @MainActor in
            do {
                characters = try await api.fetchCharacters(filter: filter)
            } catch {
                self.characters = []
                self.error = error
            }
            isLoading = false
        }
    }
}


