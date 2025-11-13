//
//  UIImage+withPadding.swift
//  VideoFrames
//
//  Created by apple on 04/02/25.
//

import Foundation
import UIKit

extension UIImage {
    func withPadding(_ insets: UIEdgeInsets) -> UIImage? {
        let newSize = CGSize(width: self.size.width + insets.left + insets.right,
                             height: self.size.height + insets.top + insets.bottom)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)

        let paddedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return paddedImage
    }
    
}
extension UIImage {
    func resizedAspectFit(to maxSize: CGSize) -> UIImage? {
        let aspectWidth = maxSize.width / size.width
        let aspectHeight = maxSize.height / size.height
        let aspectRatio = min(aspectWidth, aspectHeight) // Maintain aspect ratio

        let newSize = CGSize(width: size.width * aspectRatio, height: size.height * aspectRatio)
        return resized(to: newSize)
    }
}

extension UIImage {
    /// Resize an image to a specific size
    func resized(to size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
