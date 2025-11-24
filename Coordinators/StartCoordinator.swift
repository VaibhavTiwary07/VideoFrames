//
//  StartCoordinator.swift
//  VideoFrames
//
//  Coordinator for the start/splash screen flow
//

import UIKit

// MARK: - Start Coordinator
final class StartCoordinator: Coordinator {

    // MARK: - Properties
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    weak var delegate: StartCoordinatorDelegate?

    // MARK: - Initialization
    init(navigationController: UINavigationController) {
        print("--- StartCoordinator.swift: init ---")
        self.navigationController = navigationController
    }

    // MARK: - Coordinator Methods
    func start() {
        print("--- StartCoordinator.swift: start() ---")
        let startVC = StartViewController()
        startVC.coordinator = self
        navigationController.setViewControllers([startVC], animated: false)
    }

    // MARK: - Navigation Methods

    /// Called when user wants to start the main editing flow
    func showMainFlow() {
        delegate?.startCoordinatorDidRequestMainFlow(self)
    }

    /// Show subscription view
    func showSubscription() {
        // Implement subscription view presentation
    }

    /// Show settings
    func showSettings() {
        // Implement settings presentation
    }
}
