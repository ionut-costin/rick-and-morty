//
//  Coordinator.swift
//  Rick&Morty
//
//  Created by Ionut Andrei COSTIN on 27.04.2023.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }

    func start()
}
