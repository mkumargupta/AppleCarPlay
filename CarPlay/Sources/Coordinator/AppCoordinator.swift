//
//  AppCoordinator.swift
//  CarPlayDemo
//
//  Created by Apple on 09/05/25.
//

import UIKit

// MARK: - Coordinator

// AppCoordinator.swift
final class AppCoordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = AppDIContainer.shared.makeSongListViewModel()
        let viewController = SongListViewController(viewModel: viewModel)
        navigationController.viewControllers = [viewController]
    }
}
