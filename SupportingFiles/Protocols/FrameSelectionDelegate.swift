//
//  FrameSelectionDelegate.swift
//  VideoFrames
//
//  Protocol definitions for frame management
//

import Foundation
import UIKit

// MARK: - Frame Selection Delegate
protocol FrameSelectionDelegate: AnyObject {
    /// Called when a frame is selected
    func didSelectFrame(_ frame: FrameItemModel, at index: Int)

    /// Called when frame selection is cancelled
    func didCancelFrameSelection()

    /// Called when a locked frame is tapped
    func didTapLockedFrame(_ frame: FrameItemModel, lockType: FrameLockType)
}

// MARK: - Photo Slot Delegate
protocol PhotoSlotDelegate: AnyObject {
    /// Called when an empty photo slot is tapped
    func didTapEmptySlot(_ slot: PhotoSlotModel)

    /// Called when a photo slot with content is tapped
    func didTapSlotWithContent(_ slot: PhotoSlotModel)

    /// Called when a slot is selected (green border)
    func didSelectSlot(_ slot: PhotoSlotModel)

    /// Called when image is added to slot
    func didAddImage(_ image: UIImage, to slot: PhotoSlotModel)

    /// Called when video is added to slot
    func didAddVideo(_ url: URL, to slot: PhotoSlotModel)

    /// Called when slot content is removed
    func didRemoveContent(from slot: PhotoSlotModel)
}

// MARK: - Frame Service Delegate
protocol FrameServiceDelegate: AnyObject {
    /// Called when frames are loaded
    func frameServiceDidLoadFrames(_ frames: [FrameItemModel])

    /// Called when frame loading fails
    func frameServiceDidFailWithError(_ error: Error)

    /// Called when frame lock status changes
    func frameServiceDidUpdateLockStatus(for frameNumber: Int, isLocked: Bool)
}

// MARK: - Session Manager Delegate
protocol SessionManagerDelegate: AnyObject {
    /// Called when session frame changes
    func sessionDidChangeFrame(to frameNumber: Int)

    /// Called when photo is added to session
    func sessionDidAddPhoto(at index: Int)

    /// Called when photo is removed from session
    func sessionDidRemovePhoto(at index: Int)

    /// Called when session is ready to export
    func sessionIsReadyToExport()
}

// MARK: - Default Implementations (Optional Methods)
extension FrameSelectionDelegate {
    func didCancelFrameSelection() {}
    func didTapLockedFrame(_ frame: FrameItemModel, lockType: FrameLockType) {}
}

extension PhotoSlotDelegate {
    func didAddVideo(_ url: URL, to slot: PhotoSlotModel) {}
    func didRemoveContent(from slot: PhotoSlotModel) {}
}
