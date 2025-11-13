//
//  FilteredStickerCell.swift
//  VideoFrames
//
//  Created by apple on 20/02/25.
//

import Foundation
import UIKit

class FilteredStickerCell: UICollectionViewCell {
    
    static let identifier = "FilteredStickerCell"
    
    let imageView: UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFit
        imgV.backgroundColor = .clear
        imgV.translatesAutoresizingMaskIntoConstraints = false
        return imgV
    }()
    
    
      override init(frame: CGRect) {
          
          super.init(frame: frame)
          contentView.addSubview(imageView)
          NSLayoutConstraint.activate ([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3)
          ])
          contentView.backgroundColor = UIColor.systemGray6.withAlphaComponent(0)
          contentView.layer.cornerRadius = 12
          
      }

      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    
}
