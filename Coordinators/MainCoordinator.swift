//
//  MainCoordinator.swift
//  VideoFrames
//
//  Coordinator for the main editing flow
//

import UIKit

// MARK: - Main Coordinator
final class MainCoordinator: NSObject, Coordinator {

    // MARK: - Properties
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    weak var delegate: MainCoordinatorDelegate?

    private var mainController: MainController?

    // MARK: - Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }

    // MARK: - Coordinator Methods
    func start() {
        let mainVC = MainController()
        mainVC.coordinator = self
        mainController = mainVC
        navigationController.pushViewController(mainVC, animated: true)
    }

    // MARK: - Navigation Methods

    /// Show frame selection screen
    func showFrameSelection() {
        let frameSelectionCoordinator = FrameSelectionCoordinator(navigationController: navigationController)
        frameSelectionCoordinator.parentCoordinator = self
        frameSelectionCoordinator.delegate = self
        childCoordinators.append(frameSelectionCoordinator)
        frameSelectionCoordinator.start()
    }

    /// Go back to start screen
    func goBack() {
        delegate?.mainCoordinatorDidFinish(self)
    }

    /// Show share screen
    func showShare() {
        // Implement share flow
    }

    /// Show effects screen
    func showEffects() {
        // Implement effects flow
    }
}

// MARK: - FrameSelectionCoordinatorDelegate
extension MainCoordinator: FrameSelectionCoordinatorDelegate {
    func frameSelectionCoordinator(_ coordinator: FrameSelectionCoordinator, didSelectFrame frame: FrameItemModel) {
        childDidFinish(coordinator)

        // Update Settings with selected frame
        let settings = Settings.instance()
        settings?.currentFrameNumber = Int32(frame.frameNumber)

        // Post notification to trigger full flow in MainController
        NotificationCenter.default.post(
            name: NSNotification.Name("newframeselected"),
            object: nil,
            userInfo: ["FrameNumber": frame.frameNumber]
        )

        // Pop back to MainController
        navigationController.popViewController(animated: true)
    }

    func frameSelectionCoordinatorDidCancel(_ coordinator: FrameSelectionCoordinator) {
        childDidFinish(coordinator)
        navigationController.popViewController(animated: true)
    }
}
