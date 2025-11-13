//
//  StickerCollectionViewCell.swift
//  AIEraseObjects
//
//  Created by Admin on 23/01/25.
//

import UIKit

class StickerCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "StickerCell"
    
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

          NSLayoutConstraint.activate([
              
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
    
    override var isSelected: Bool {
        didSet {
            if(isSelected)
            {
                imageTapped();
            }
        }
    }
    
    func imageTapped() {
        // Shrink effect
        UIView.animate(withDuration: 0.15, animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            // Bounce back to original size
            UIView.animate(withDuration: 0.15, animations: {
                self.imageView.transform = .identity
            })
        }
    }
}
