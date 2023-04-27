//
//  CharactersCoordinator.swift
//  Rick&Morty
//
//  Created by Ionut Andrei COSTIN on 27.04.2023.
//

import UIKit
import SwiftUI
import Combine
import RickMortySwiftApi

class CharactersCoordinator: Coordinator {

    private let window: UIWindow

    private let characterFilter = CurrentValueSubject<RMCharacterFilter, Never>(RMCharacterFilter())
    private let showFilter = PassthroughSubject<Bool, Never>()
    private let characterSelected = PassthroughSubject<RMCharacterModel, Never>()

    private var subscriptions: [AnyCancellable] = []

    let navigationController: UINavigationController

    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController

        setSubscriptions()
    }

    private func setSubscriptions() {
        showFilter
            .eraseToAnyPublisher()
            .sink { value in
                guard value else { return }
                let viewModel = CharacterFilterViewModel(filterSubject: self.characterFilter)
                let view = CharacterFilterView(viewModel: viewModel)
                let viewController = UIHostingController(rootView: view)
                self.navigationController.pushViewController(viewController, animated: true)
            }
            .store(in: &subscriptions)

        characterSelected
            .debounce(for: 0.1, scheduler: DispatchQueue.main)
            .sink { character in
                let view = CharacterDetailsView(character: character)
                let viewController = UIHostingController(rootView: view)
                self.navigationController.pushViewController(viewController, animated: true)
            }
            .store(in: &subscriptions)
    }

    func start() {
        let viewModel = CharactersViewModel(api: MainAPI(),
                                            filterSubject: self.characterFilter,
                                            characterSelectedSubject: self.characterSelected)
        let view = CharactersView(viewModel: viewModel, showFilter: showFilter)
        let viewController = UIHostingController(rootView: view)
        navigationController.viewControllers = [viewController]
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
