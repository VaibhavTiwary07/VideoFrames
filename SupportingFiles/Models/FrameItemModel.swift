//
//  FrameItemModel.swift
//  VideoFrames
//
//  Modern data model for frame items
//

import Foundation
import UIKit

// MARK: - Frame Lock Type
enum FrameLockType: Int {
    case free = 0
    case facebook = 1
    case instagram = 2
    case twitter = 3
    case inAppPurchase = 4
    case subscription = 5
}

// MARK: - Photo Slot State
enum PhotoSlotState {
    case empty
    case selected
    case hasImage(UIImage)
    case hasVideo(URL)

    var isEmpty: Bool {
        if case .empty = self { return true }
        return false
    }

    var isSelected: Bool {
        if case .selected = self { return true }
        return false
    }
}

// MARK: - Frame Item Model
struct FrameItemModel {
    let frameNumber: Int
    let thumbnailName: String
    let lockType: FrameLockType
    let photoCount: Int

    var isLocked: Bool {
        return lockType != .free
    }

    var thumbnailImage: UIImage? {
        return UIImage(named: thumbnailName)
    }

    // Selected thumbnail (highlighted version)
    var selectedThumbnailName: String {
        let number = frameNumber < 10 ? "0\(frameNumber)" : "\(frameNumber)"
        return "thumbles_\(number)_Colored.png"
    }

    var selectedThumbnailImage: UIImage? {
        return UIImage(named: selectedThumbnailName)
    }
}

// MARK: - Frame Selection State
struct FrameSelectionState {
    var frames: [FrameItemModel] = []
    var selectedIndex: Int?
    var isLoading: Bool = false
    var error: Error?

    var selectedFrame: FrameItemModel? {
        guard let index = selectedIndex, index < frames.count else { return nil }
        return frames[index]
    }
}

// MARK: - Photo Slot Model
struct PhotoSlotModel {
    let index: Int
    var state: PhotoSlotState = .empty
    var image: UIImage?
    var videoURL: URL?
    var isContentTypeVideo: Bool = false

    mutating func setImage(_ image: UIImage) {
        self.image = image
        self.state = .hasImage(image)
        self.isContentTypeVideo = false
    }

    mutating func setVideo(_ url: URL, thumbnail: UIImage) {
        self.videoURL = url
        self.image = thumbnail
        self.state = .hasVideo(url)
        self.isContentTypeVideo = true
    }

    mutating func clear() {
        self.image = nil
        self.videoURL = nil
        self.state = .empty
        self.isContentTypeVideo = false
    }

    mutating func select() {
        if case .empty = state {
            state = .selected
        }
    }

    mutating func deselect() {
        if case .selected = state {
            state = .empty
        }
    }
}
