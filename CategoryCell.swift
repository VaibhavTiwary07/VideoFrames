//
//  CustomCollectionViewCell.swift
//  Stickers
//
//  Created by apple on 23/01/25.
//

import Foundation
import UIKit

class CategoryCell: UICollectionViewCell {
    // UNUSED: static let identifier = "CategoryCell"
    
    // Add an image view
//    private let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        imageView.clipsToBounds = true
//        return imageView
//    }()
    
    // Add a label
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Gilroy-Medium", size: 20)//UIFont.systemFont(ofSize: 15, weight: .medium)
        //label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add subviews to the cell
        //contentView.addSubview(imageView)
        contentView.addSubview(label)
        
        // Enable Auto Layout
    //    imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Set constraints for image view and label
        NSLayoutConstraint.activate([
//            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
//            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            imageView.widthAnchor.constraint(equalToConstant: 60),
//            imageView.heightAnchor.constraint(equalToConstant: 60),
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UNUSED:
    /*
    // Configure the cell with data
    func configure(text: String) {//imageName: String,
      //  imageView.image = UIImage(named: imageName)
        label.text = text
    }
    */
}
