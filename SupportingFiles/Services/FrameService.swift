//
//  FrameService.swift
//  VideoFrames
//
//  Service for loading and managing frames
//

import Foundation
import UIKit

// MARK: - Frame Service
final class FrameService {

    // MARK: - Singleton
    static let shared = FrameService()

    // MARK: - Properties
    private let imageCache = NSCache<NSString, UIImage>()
    private var frames: [FrameItemModel] = []
    private let totalFrameCount = 99

    weak var delegate: FrameServiceDelegate?

    // MARK: - Frame Lock Mapping (from original FrameSelectionController.m)
    private let frameLockMapping: [Int: FrameLockType] = [
        // Free frames
        1: .free, 2: .free, 9: .free, 19: .free, 31: .free,
        36: .free, 39: .free, 69: .free, 73: .free, 85: .free,
        // Social unlock frames
        3: .facebook, 4: .facebook,
        5: .instagram, 6: .instagram,
        7: .twitter, 8: .twitter,
        // Subscription frames (all others)
        10: .subscription, 11: .subscription, 12: .subscription, 13: .subscription, 14: .subscription,
        15: .subscription, 16: .subscription, 17: .subscription, 18: .subscription, 20: .subscription,
        21: .subscription, 22: .subscription, 23: .subscription, 24: .subscription, 25: .subscription,
        26: .subscription, 27: .subscription, 28: .subscription, 29: .subscription, 30: .subscription,
        32: .subscription, 33: .subscription, 34: .subscription, 35: .subscription, 37: .subscription,
        38: .subscription, 40: .subscription, 41: .subscription, 42: .subscription, 43: .subscription,
        44: .subscription, 45: .subscription, 46: .subscription, 47: .subscription, 48: .subscription,
        49: .subscription, 50: .subscription, 51: .subscription, 52: .subscription, 53: .subscription,
        54: .subscription, 55: .subscription, 56: .subscription, 57: .subscription, 58: .subscription,
        59: .subscription, 60: .subscription, 61: .subscription, 62: .subscription, 63: .subscription,
        64: .subscription, 65: .subscription, 66: .subscription, 67: .subscription, 68: .subscription,
        70: .subscription, 71: .subscription, 72: .subscription, 74: .subscription, 75: .subscription,
        76: .subscription, 77: .subscription, 78: .subscription, 79: .subscription, 80: .subscription,
        81: .subscription, 82: .subscription, 83: .subscription, 84: .subscription, 86: .subscription,
        87: .subscription, 88: .subscription, 89: .subscription, 90: .subscription, 91: .subscription,
        92: .subscription, 93: .subscription, 94: .subscription, 95: .subscription, 96: .subscription,
        97: .subscription, 98: .subscription, 99: .subscription
    ]

    // MARK: - Initialization
    private init() {
        print("--- FrameService.swift: init ---")
        setupCache()
    }

    private func setupCache() {
        imageCache.countLimit = 250
        imageCache.totalCostLimit = 50 * 1024 * 1024 // 50MB
    }

    // MARK: - Public Methods

    /// Load all frames
    func loadFrames(completion: @escaping ([FrameItemModel]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            var loadedFrames: [FrameItemModel] = []

            for i in 1...self.totalFrameCount {
                let thumbnailName = self.thumbnailName(for: i)
                let lockType = self.frameLockMapping[i] ?? .free
                let photoCount = self.photoCount(for: i)

                let frame = FrameItemModel(
                    frameNumber: i,
                    thumbnailName: thumbnailName,
                    lockType: lockType,
                    photoCount: photoCount
                )
                loadedFrames.append(frame)
            }

            self.frames = loadedFrames

            DispatchQueue.main.async {
                self.delegate?.frameServiceDidLoadFrames(loadedFrames)
                completion(loadedFrames)
            }
        }
    }

    /// Get frame at index
    func getFrame(at index: Int) -> FrameItemModel? {
        guard index >= 0 && index < frames.count else { return nil }
        return frames[index]
    }

    /// Get all frames
    func getAllFrames() -> [FrameItemModel] {
        return frames
    }

    /// Check if frame is locked
    func isFrameLocked(_ frameNumber: Int) -> Bool {
        let lockType = frameLockMapping[frameNumber] ?? .free
        if lockType == .free { return false }

        // Check unlock status from Settings
        return !isFrameUnlocked(frameNumber, lockType: lockType)
    }

    /// Get cached thumbnail image
    func getThumbnailImage(for frameNumber: Int, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = "frame_\(frameNumber)" as NSString

        // Check cache first
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            completion(cachedImage)
            return
        }

        // Load from assets
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let thumbnailName = self?.thumbnailName(for: frameNumber) ?? ""
            let image = UIImage(named: thumbnailName)

            if let image = image {
                self?.imageCache.setObject(image, forKey: cacheKey)
            }

            DispatchQueue.main.async {
                completion(image)
            }
        }
    }

    /// Clear image cache
    func clearCache() {
        imageCache.removeAllObjects()
    }

    // MARK: - Private Methods

    private func thumbnailName(for frameNumber: Int) -> String {
        let number = frameNumber < 10 ? "0\(frameNumber)" : "\(frameNumber)"
        return "thumbles_\(number).png"
    }

    private func photoCount(for frameNumber: Int) -> Int {
        // Convert new frame number (1-99) to database format using original page-based logic
        let dbFrameNumber = convertIndexToDbFrameNumber(frameNumber - 1)
        let count = FrameDB.getPhotoCount(forFrameNumber: Int32(dbFrameNumber))
        return Int(count)
    }

    // Convert display index to database frame number using original page-based logic
    private func convertIndexToDbFrameNumber(_ index: Int) -> Int {
        let rowsPerPage = 4
        let colPerPage = 3
        let itemsPerPage = rowsPerPage * colPerPage  // 12
        let pageNumber = index / itemsPerPage
        let indexInsidePage = index % itemsPerPage
        var items = pageNumber * (itemsPerPage / 2)  // pageNumber * 6

        // Top half of page (positions 0-6): FREE frames
        if indexInsidePage < ((rowsPerPage / 2) * colPerPage) + 1 {  // < 7
            return items + indexInsidePage
        }

        // Bottom half of page: PREMIUM frames
        items = items + (indexInsidePage - ((rowsPerPage / 2) * colPerPage))
        return 1000 + items
    }

    private func isFrameUnlocked(_ frameNumber: Int, lockType: FrameLockType) -> Bool {
        // Check unlock status from UserDefaults and subscription model
        let defaults = UserDefaults.standard

        switch lockType {
        case .free:
            return true
        case .facebook:
            return defaults.bool(forKey: "isFacebookShared")
        case .instagram:
            return defaults.bool(forKey: "isInstagramShared")
        case .twitter:
            return defaults.bool(forKey: "isTwitterShared")
        case .inAppPurchase:
            return defaults.bool(forKey: "isPurchasedAllFrames")
        case .subscription:
            // Check subscription status from SRSubscriptionModel
            return SRSubscriptionModel.shareKit()?.isAppSubscribed() ?? false
        }
    }
}

// MARK: - Frame Service Error
enum FrameServiceError: Error {
    case frameNotFound
    case loadingFailed
    case invalidIndex
}
