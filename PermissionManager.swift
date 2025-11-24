//
//  PermissionManager.swift
//  VideoFrames
//
//  Modern permission handling for Photos and Camera
//

import Foundation
import Photos
import AVFoundation
import UIKit

@objc public class PermissionManager: NSObject {

    @objc public static let shared = PermissionManager()

    private override init() {
        super.init()
    }

    // MARK: - Photo Library Permission

    @objc public func requestPhotoLibraryAccess(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)

        switch status {
        case .authorized, .limited:
            DispatchQueue.main.async {
                completion(true)
            }
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized || newStatus == .limited)
                }
            }
        case .denied, .restricted:
            DispatchQueue.main.async {
                completion(false)
            }
        @unknown default:
            DispatchQueue.main.async {
                completion(false)
            }
        }
    }

    @objc public func checkPhotoLibraryStatus() -> PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }

    // MARK: - Camera Permission

    @objc public func requestCameraAccess(completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)

        switch status {
        case .authorized:
            DispatchQueue.main.async {
                completion(true)
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        case .denied, .restricted:
            DispatchQueue.main.async {
                completion(false)
            }
        @unknown default:
            DispatchQueue.main.async {
                completion(false)
            }
        }
    }

    @objc public func checkCameraStatus() -> AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }

    // MARK: - Settings Navigation

    @objc public func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }

    // MARK: - Alert Helpers

    @objc public func showPhotoLibraryDeniedAlert(from viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Photo Library Access Required",
            message: "Please allow access to your photo library in Settings to select photos and videos.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { [weak self] _ in
            self?.openAppSettings()
        })

        viewController.present(alert, animated: true)
    }

    @objc public func showCameraDeniedAlert(from viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Camera Access Required",
            message: "Please allow camera access in Settings to take photos.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { [weak self] _ in
            self?.openAppSettings()
        })

        viewController.present(alert, animated: true)
    }

    @objc public func showLimitedAccessAlert(from viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Limited Photo Access",
            message: "You've granted limited access to your photos. Would you like to allow access to more photos?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Keep Current Selection", style: .cancel))
        alert.addAction(UIAlertAction(title: "Select More Photos", style: .default) { _ in
            if #available(iOS 14, *) {
                PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: viewController)
            }
        })
        alert.addAction(UIAlertAction(title: "Allow Full Access", style: .default) { [weak self] _ in
            self?.openAppSettings()
        })

        viewController.present(alert, animated: true)
    }
}
