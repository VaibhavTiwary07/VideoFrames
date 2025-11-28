//
//  MainController+FrameSelection.swift
//  VideoFrames
//
//  Extension to integrate MainController with new MVVM architecture
//

import UIKit

// MARK: - Frame Selection Delegate
extension MainController: FrameSelectionDelegate {

    func didSelectFrame(_ frame: FrameItemModel, at index: Int) {
        // Set frame number in Settings (required by loadTheSession)
        let settings = Settings.instance()
        settings?.currentFrameNumber = Int32(frame.frameNumber)

        // Direct call to MainController method
        self.applyNewFrameSelection(Int(frame.frameNumber))

        // Log for debugging
        print("Frame selected: \(frame.frameNumber) at index: \(index)")
    }

    func didCancelFrameSelection() {
        // Handle cancellation if needed
        print("Frame selection cancelled")
    }

    func didTapLockedFrame(_ frame: FrameItemModel, lockType: FrameLockType) {
        // Show unlock options based on lock type
        handleLockedFrame(frame: frame, lockType: lockType)
    }

    // MARK: - Private Helpers

    private func handleLockedFrame(frame: FrameItemModel, lockType: FrameLockType) {
        switch lockType {
        case .free:
            break // Should not happen

        case .facebook:
            showSocialSharePrompt(for: "Facebook")

        case .instagram:
            showSocialSharePrompt(for: "Instagram")

        case .twitter:
            showSocialSharePrompt(for: "Twitter")

        case .inAppPurchase:
            showInAppPurchasePrompt()

        case .subscription:
            showSubscriptionPrompt()
        }
    }

    private func showSocialSharePrompt(for platform: String) {
        let alert = UIAlertController(
            title: "Unlock Frame",
            message: "Share on \(platform) to unlock this frame",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Share", style: .default) { _ in
            // Trigger share flow
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func showInAppPurchasePrompt() {
        let alert = UIAlertController(
            title: "Unlock Frame",
            message: "Purchase to unlock this frame",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Purchase", style: .default) { _ in
            // Trigger IAP flow
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func showSubscriptionPrompt() {
        // Use existing subscription view
        self.perform(NSSelectorFromString("ShowSubscriptionView"))
    }
}

// MARK: - Photo Slot Delegate
extension MainController: PhotoSlotDelegate {

    func didTapEmptySlot(_ slot: PhotoSlotModel) {
        // Show photo/video picker - handled by existing notification system
        print("Empty slot tapped: \(slot.index)")
    }

    func didTapSlotWithContent(_ slot: PhotoSlotModel) {
        // Show edit menu - handled by existing notification system
        print("Slot with content tapped: \(slot.index)")
    }

    func didSelectSlot(_ slot: PhotoSlotModel) {
        // Deselect other slots - handled by handlePhotoSlotSelected notification
        print("Slot selected: \(slot.index)")
    }

    func didAddImage(_ image: UIImage, to slot: PhotoSlotModel) {
        // Image was added to slot
        print("Image added to slot: \(slot.index)")
    }

    func didAddVideo(_ url: URL, to slot: PhotoSlotModel) {
        // Video was added to slot
        print("Video added to slot: \(slot.index)")
    }

    func didRemoveContent(from slot: PhotoSlotModel) {
        // Content was removed
        print("Content removed from slot: \(slot.index)")
    }
}

// MARK: - Navigation Helper
extension MainController {

    /// Present new frame selection view controller
    @objc func presentNewFrameSelection() {
        let viewModel = FrameSelectionViewModel()
        let frameVC = FrameSelectionViewControllerNew(viewModel: viewModel)
        frameVC.delegate = self

        navigationController?.pushViewController(frameVC, animated: false)
    }
}
