//
//  Coordinator.swift
//  VideoFrames
//
//  Coordinator pattern protocol for navigation management
//

import UIKit

// MARK: - Coordinator Protocol
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var parentCoordinator: Coordinator? { get set }

    func start()
    func childDidFinish(_ child: Coordinator)
}

// MARK: - Default Implementation
extension Coordinator {
    func childDidFinish(_ child: Coordinator) {
        childCoordinators.removeAll { $0 === child }
    }
}

// MARK: - Start Coordinator Delegate
protocol StartCoordinatorDelegate: AnyObject {
    func startCoordinatorDidRequestMainFlow(_ coordinator: StartCoordinator)
}

// MARK: - Main Coordinator Delegate
protocol MainCoordinatorDelegate: AnyObject {
    func mainCoordinatorDidFinish(_ coordinator: MainCoordinator)
    func mainCoordinatorDidRequestFrameSelection(_ coordinator: MainCoordinator)
}

// MARK: - Frame Selection Coordinator Delegate
protocol FrameSelectionCoordinatorDelegate: AnyObject {
    func frameSelectionCoordinator(_ coordinator: FrameSelectionCoordinator, didSelectFrame frame: FrameItemModel)
    func frameSelectionCoordinatorDidCancel(_ coordinator: FrameSelectionCoordinator)
}
