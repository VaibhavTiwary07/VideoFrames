//
//  BottomCollectionViewCell.swift
//  AIEraseObjects
//
//  Created by Admin on 24/01/25.
//


import UIKit

class BottomCollectionViewCell: UICollectionViewCell {
    
    // Create a label that acts as a top border
    let topBorderLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray  // Default color
        label.layer.cornerRadius = 1.5        // Rounded edges
        label.isHidden = true
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageView: UIImageView = {
        let imgV = UIImageView()
        imgV.backgroundColor = .clear
        imgV.contentMode = .scaleAspectFit
        imgV.translatesAutoresizingMaskIntoConstraints = false
        return imgV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(topBorderLabel)
        
        NSLayoutConstraint.activate([
            topBorderLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -5), // Slightly outside
            topBorderLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            topBorderLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.65), // Not full width
            topBorderLabel.heightAnchor.constraint(equalToConstant: 3) // Adjust thickness here
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topBorderLabel.bottomAnchor, constant: 2),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        contentView.layer.cornerRadius = 8
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Highlight the selected cell by changing label color
    override var isSelected: Bool {
        didSet {
            topBorderLabel.backgroundColor = isSelected ? .clear : .systemGray  // Change color when selected
        }
    }
    
    func updateSelection(isSelected: Bool) {
           topBorderLabel.isHidden = !isSelected  // Show only if selected
       }
}

