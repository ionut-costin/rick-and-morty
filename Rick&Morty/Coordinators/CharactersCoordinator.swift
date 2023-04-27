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
    private let charactersViewModel = CharactersViewModel(api: CharactersAPI())

    private var subscriptions: [AnyCancellable] = []

    let navigationController: UINavigationController

    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController

        setSubscriptions()
    }

    private func setSubscriptions() {
        charactersViewModel.showFilerPublisher
            .sink { show in
                guard show else { return }
                self.showFilterView()
            }
            .store(in: &subscriptions)

        charactersViewModel.characterSelectedPublisher
            .debounce(for: 0.1, scheduler: DispatchQueue.main)
            .sink(receiveValue: showCharacterDetails(_:))
            .store(in: &subscriptions)
    }

    func start() {
        let view = CharactersView(viewModel: self.charactersViewModel)
        let viewController = UIHostingController(rootView: view)
        navigationController.viewControllers = [viewController]
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func showFilterView() {
        let view = CharacterFilterView(viewModel: self.charactersViewModel)
        let viewController = UIHostingController(rootView: view)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showCharacterDetails(_ character: RMCharacterModel) {
        let view = CharacterDetailsView(character: character)
        let viewController = UIHostingController(rootView: view)
        navigationController.pushViewController(viewController, animated: true)
    }
}
