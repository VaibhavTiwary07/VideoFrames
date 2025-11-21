//
//  FrameSelectionCoordinator.swift
//  VideoFrames
//
//  Coordinator for frame selection flow
//

import UIKit

// MARK: - Frame Selection Coordinator
final class FrameSelectionCoordinator: Coordinator {

    // MARK: - Properties
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: Coordinator?
    weak var delegate: FrameSelectionCoordinatorDelegate?

    private var frameSelectionVC: FrameSelectionViewControllerNew?

    // MARK: - Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Coordinator Methods
    func start() {
        let viewModel = FrameSelectionViewModel()
        let frameVC = FrameSelectionViewControllerNew(viewModel: viewModel)
        frameVC.coordinator = self
        frameSelectionVC = frameVC
        navigationController.pushViewController(frameVC, animated: true)
    }

    // MARK: - Navigation Methods

    /// Called when user selects a frame and presses Done
    func didSelectFrame(_ frame: FrameItemModel) {
        delegate?.frameSelectionCoordinator(self, didSelectFrame: frame)
    }

    /// Called when user cancels frame selection
    func didCancel() {
        delegate?.frameSelectionCoordinatorDidCancel(self)
    }
}
