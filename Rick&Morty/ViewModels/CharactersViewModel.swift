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
    // MARK: - Did Sets
    var filter = RMCharacterFilter() {
        didSet { fetchCharacters() }
    }

    var characterSelected: RMCharacterModel? {
        didSet {
            guard let characterSelected = characterSelected else { return }
            characterSelectedSubject.send(characterSelected)
        }
    }

    // MARK: - Properties
    private let api: API

    let showFilterSubject = PassthroughSubject<Bool, Never>()
    lazy var showFilerPublisher = showFilterSubject.eraseToAnyPublisher()

    private let characterSelectedSubject = PassthroughSubject<RMCharacterModel, Never>()
    lazy var characterSelectedPublisher = characterSelectedSubject.eraseToAnyPublisher()

    private var subscriptions: [AnyCancellable] = []

    @Published var isLoading = false
    @Published var search: String = ""
    @Published public var characters: [RMCharacterModel] = []
    @Published var error: Error?

    // MARK: - Init
    init(api: API) {
        self.api = api

        setSubscribers()
    }

    private func setSubscribers() {
        $search
            .dropFirst()
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .assign(to: \.filter.name, on: self)
            .store(in: &subscriptions)
    }

    public func fetchCharacters() {
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
