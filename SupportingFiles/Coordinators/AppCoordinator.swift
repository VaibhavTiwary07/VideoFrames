//
//  AppCoordinator.swift
//  VideoFrames
//
//  Root coordinator that manages the app's navigation flow
//

import UIKit

// MARK: - App Coordinator
final class AppCoordinator: Coordinator {

    // MARK: - Properties
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?

    private let window: UIWindow

    // MARK: - Initialization
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        setupNavigationBarAppearance()
    }

    // MARK: - Coordinator Methods
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        showStartFlow()
    }

    // MARK: - Flow Methods
    private func showStartFlow() {
        let startCoordinator = StartCoordinator(navigationController: navigationController)
        startCoordinator.parentCoordinator = self
        startCoordinator.delegate = self
        childCoordinators.append(startCoordinator)
        startCoordinator.start()
    }

    private func showMainFlow() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        mainCoordinator.parentCoordinator = self
        mainCoordinator.delegate = self
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
    }

    // MARK: - Navigation Bar Setup
    private func setupNavigationBarAppearance() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .black
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.white,
                .font: UIFont.boldSystemFont(ofSize: 17)
            ]

            navigationController.navigationBar.standardAppearance = appearance
            navigationController.navigationBar.scrollEdgeAppearance = appearance
        }
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.isTranslucent = false
    }
}

// MARK: - StartCoordinatorDelegate
extension AppCoordinator: StartCoordinatorDelegate {
    func startCoordinatorDidRequestMainFlow(_ coordinator: StartCoordinator) {
        showMainFlow()
    }
}

// MARK: - MainCoordinatorDelegate
extension AppCoordinator: MainCoordinatorDelegate {
    func mainCoordinatorDidFinish(_ coordinator: MainCoordinator) {
        childDidFinish(coordinator)
        navigationController.popToRootViewController(animated: true)
    }

    func mainCoordinatorDidRequestFrameSelection(_ coordinator: MainCoordinator) {
        // MainCoordinator handles its own frame selection
    }
}
