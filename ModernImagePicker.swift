//
//  ModernImagePicker.swift
//  VideoFrames
//
//  Modern PHPickerViewController wrapper for iOS 14+
//

import Foundation
import PhotosUI
import UIKit
import AVFoundation

@objc public protocol ModernImagePickerDelegate: AnyObject {
    @objc func modernImagePicker(_ picker: ModernImagePicker, didSelectImages images: [UIImage])
    @objc func modernImagePicker(_ picker: ModernImagePicker, didSelectVideoAt url: URL)
    @objc func modernImagePickerDidCancel(_ picker: ModernImagePicker)
    @objc optional func modernImagePicker(_ picker: ModernImagePicker, didFailWithError error: Error)
}

@objc public class ModernImagePicker: NSObject {

    @objc public weak var delegate: ModernImagePickerDelegate?
    @objc public weak var presentingViewController: UIViewController?

    private var maxSelection: Int = 1
    private var isVideoSelection: Bool = false

    @objc public init(viewController: UIViewController) {
        self.presentingViewController = viewController
        super.init()
    }

    // MARK: - Public Methods

    @objc public func pickImages(maxCount: Int) {
        maxSelection = maxCount
        isVideoSelection = false

        PermissionManager.shared.requestPhotoLibraryAccess { [weak self] granted in
            guard let self = self else { return }

            if granted {
                self.presentImagePicker()
            } else {
                if let vc = self.presentingViewController {
                    PermissionManager.shared.showPhotoLibraryDeniedAlert(from: vc)
                }
            }
        }
    }

    @objc public func pickVideo() {
        maxSelection = 1
        isVideoSelection = true

        PermissionManager.shared.requestPhotoLibraryAccess { [weak self] granted in
            guard let self = self else { return }

            if granted {
                self.presentVideoPicker()
            } else {
                if let vc = self.presentingViewController {
                    PermissionManager.shared.showPhotoLibraryDeniedAlert(from: vc)
                }
            }
        }
    }

    // MARK: - Private Methods

    private func presentImagePicker() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = maxSelection
        configuration.filter = .images
        configuration.preferredAssetRepresentationMode = .current

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen

        presentingViewController?.present(picker, animated: true)
    }

    private func presentVideoPicker() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = 1
        configuration.filter = .videos
        configuration.preferredAssetRepresentationMode = .current

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen

        presentingViewController?.present(picker, animated: true)
    }
}

// MARK: - PHPickerViewControllerDelegate

extension ModernImagePicker: PHPickerViewControllerDelegate {

    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

        if results.isEmpty {
            picker.dismiss(animated: true) {
                self.delegate?.modernImagePickerDidCancel(self)
            }
            return
        }

        if isVideoSelection {
            handleVideoSelection(results: results, picker: picker)
        } else {
            handleImageSelection(results: results, picker: picker)
        }
    }

    private func handleImageSelection(results: [PHPickerResult], picker: PHPickerViewController) {
        var selectedImages: [UIImage] = []
        let group = DispatchGroup()

        for result in results {
            group.enter()

            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                    if let error = error {
                        print("Error loading image: \(error.localizedDescription)")
                    } else if let image = object as? UIImage {
                        selectedImages.append(image)
                    }
                    group.leave()
                }
            } else {
                group.leave()
            }
        }

        group.notify(queue: .main) {
            picker.dismiss(animated: true) {
                if selectedImages.isEmpty {
                    let error = NSError(domain: "ModernImagePicker", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to load images"])
                    self.delegate?.modernImagePicker?(self, didFailWithError: error)
                } else {
                    self.delegate?.modernImagePicker(self, didSelectImages: selectedImages)
                }
            }
        }
    }

    private func handleVideoSelection(results: [PHPickerResult], picker: PHPickerViewController) {
        guard let result = results.first else {
            picker.dismiss(animated: true)
            return
        }

        let identifier = UTType.movie.identifier

        if result.itemProvider.hasItemConformingToTypeIdentifier(identifier) {
            result.itemProvider.loadFileRepresentation(forTypeIdentifier: identifier) { [weak self] url, error in
                guard let self = self else { return }

                if let error = error {
                    print("Error loading video: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        picker.dismiss(animated: true) {
                            self.delegate?.modernImagePicker?(self, didFailWithError: error)
                        }
                    }
                    return
                }

                guard let sourceURL = url else {
                    DispatchQueue.main.async {
                        picker.dismiss(animated: true)
                    }
                    return
                }

                // IMPORTANT: Copy immediately while URL is still valid
                // The URL becomes invalid after this callback ends
                let tempURL = self.copyVideoToTemp(from: sourceURL)

                DispatchQueue.main.async {
                    picker.dismiss(animated: true) {
                        if let videoURL = tempURL {
                            self.delegate?.modernImagePicker(self, didSelectVideoAt: videoURL)
                        } else {
                            let error = NSError(domain: "ModernImagePicker", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to copy video"])
                            self.delegate?.modernImagePicker?(self, didFailWithError: error)
                        }
                    }
                }
            }
        }
    }

    private func copyVideoToTemp(from sourceURL: URL) -> URL? {
        let tempDir = FileManager.default.temporaryDirectory
        let fileExtension = sourceURL.pathExtension.isEmpty ? "mov" : sourceURL.pathExtension
        let fileName = "picked_video_\(Date().timeIntervalSince1970).\(fileExtension)"
        let destinationURL = tempDir.appendingPathComponent(fileName)

        do {
            // Verify source file exists and is readable
            guard FileManager.default.fileExists(atPath: sourceURL.path) else {
                print("Error: Source video file does not exist at \(sourceURL.path)")
                return nil
            }

            // Remove existing file if present
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }

            // Copy the video file
            try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
            print("Video copied successfully to: \(destinationURL.path)")
            return destinationURL
        } catch {
            print("Error copying video: \(error.localizedDescription)")
            print("Source: \(sourceURL.path)")
            print("Destination: \(destinationURL.path)")
            return nil
        }
    }
}
