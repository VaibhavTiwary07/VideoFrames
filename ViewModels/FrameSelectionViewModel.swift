//
//  FrameSelectionViewModel.swift
//  VideoFrames
//
//  ViewModel for frame selection screen
//

import Foundation
import UIKit

// MARK: - Frame Selection ViewModel
final class FrameSelectionViewModel {

    // MARK: - Properties
    private let frameService: FrameService
    private(set) var state = FrameSelectionState()

    // Callbacks for UI updates
    var onFramesLoaded: (([FrameItemModel]) -> Void)?
    var onSelectionChanged: ((Int?, Int?) -> Void)?
    var onError: ((Error) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?

    weak var delegate: FrameSelectionDelegate?

    // MARK: - Computed Properties
    var frameCount: Int {
        return state.frames.count
    }

    var selectedIndex: Int? {
        return state.selectedIndex
    }

    var selectedFrame: FrameItemModel? {
        return state.selectedFrame
    }

    // MARK: - Initialization
    init(frameService: FrameService = .shared) {
        self.frameService = frameService
    }

    // MARK: - Public Methods

    /// Load frames from service
    func loadFrames() {
        state.isLoading = true
        onLoadingStateChanged?(true)

        frameService.loadFrames { [weak self] frames in
            guard let self = self else { return }

            self.state.frames = frames
            self.state.isLoading = false

            self.onLoadingStateChanged?(false)
            self.onFramesLoaded?(frames)
        }
    }

    /// Get frame at index
    func frame(at index: Int) -> FrameItemModel? {
        guard index >= 0 && index < state.frames.count else { return nil }
        return state.frames[index]
    }

    /// Select frame at index
    func selectFrame(at index: Int) {
        guard let frame = frame(at: index) else { return }

        // Check if frame is locked
        if frame.isLocked && frameService.isFrameLocked(frame.frameNumber) {
            delegate?.didTapLockedFrame(frame, lockType: frame.lockType)
            return
        }

        let previousIndex = state.selectedIndex
        state.selectedIndex = index

        // Notify UI of selection change
        onSelectionChanged?(previousIndex, index)

        // Note: Don't call delegate here - only call when Done button is pressed
        // This allows browsing frames without immediately applying them
    }

    /// Deselect current frame
    func deselectFrame() {
        let previousIndex = state.selectedIndex
        state.selectedIndex = nil
        onSelectionChanged?(previousIndex, nil)
    }

    /// Check if frame at index is selected
    func isSelected(at index: Int) -> Bool {
        return state.selectedIndex == index
    }

    /// Check if frame at index is locked
    func isLocked(at index: Int) -> Bool {
        guard let frame = frame(at: index) else { return false }
        return frameService.isFrameLocked(frame.frameNumber)
    }

    /// Get thumbnail for frame at index
    func getThumbnail(at index: Int, completion: @escaping (UIImage?) -> Void) {
        guard let frame = frame(at: index) else {
            completion(nil)
            return
        }

        frameService.getThumbnailImage(for: frame.frameNumber, completion: completion)
    }

    /// Cancel selection
    func cancel() {
        delegate?.didCancelFrameSelection()
    }

    // MARK: - Private Methods

    private func saveSelection(frameNumber: Int) {
        // Save to UserDefaults
        UserDefaults.standard.set(frameNumber, forKey: "selectedFrameNumber")
    }
}

// MARK: - Cell Configuration Helper
extension FrameSelectionViewModel {

    /// Configure cell data
    func cellData(at index: Int) -> FrameCellData? {
        guard let frame = frame(at: index) else { return nil }

        return FrameCellData(
            frameNumber: frame.frameNumber,
            thumbnailName: frame.thumbnailName,  // Use normal thumbnail
            isSelected: isSelected(at: index),
            isLocked: frame.lockType != .free  // Show badge for ALL non-free frames
        )
    }
}

// MARK: - Cell Data Model
struct FrameCellData {
    let frameNumber: Int
    let thumbnailName: String
    let isSelected: Bool
    let isLocked: Bool
}
