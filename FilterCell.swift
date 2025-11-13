//
//  FilterCell.swift
//  VideoFrames
//
//  Created by apple on 13/03/25.
//

import Foundation
import UIKit

class FilterCell: UICollectionViewCell {
    let cellsize : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 100 : 75
    static let identifier = "FilterCell"
   
    private let bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        //imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
//        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let containerView : UIImageView =
    {
        let view = UIImageView()
       // view.layer.cornerRadius = 8;
        return view;
        
    }()
    
//    private let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.layer.cornerRadius = 10
//        imageView.clipsToBounds = true
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
    
    private let lockImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "n_lock_corner"))
        //imageView.tintColor = .white
        imageView.backgroundColor = .clear //UIColor.black.withAlphaComponent(0.6)
       // imageView.layer.cornerRadius = 10
       // imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    override var isSelected: Bool {
        didSet {
            
            
            containerView.clipsToBounds = true
            containerView.layer.borderColor = isSelected ? UIColor.systemCyan.cgColor:UIColor.clear.cgColor
            containerView.layer.borderWidth = 3
            if(isSelected)
            {
                imageTapped();
            }
        }
    }
    
    
    
//    func imageTapped() {
//        // Shrink effect
//        UIView.animate(withDuration: 0.15, animations: {
//            self.imageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//        }) { _ in
//            // Bounce back to original size
//            UIView.animate(withDuration: 0.15, animations: {
//                self.imageView.transform = .identity
//            })
//        }
//    }
    
    func imageTapped() {
           // Shrink effect
           UIView.animate(withDuration: 0.1, animations: {
               self.bgImageView.transform = CGAffineTransform(scaleX: 1.15, y: 1.3)
           }) { _ in
               // Bounce back to original size
               UIView.animate(withDuration: 0.1, animations: {
                   self.bgImageView.transform = .identity
                  // self.bgImageView.backgroundColor = .clear
               })
           }
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        var padding:CGFloat = 5
        if UIDevice.current.userInterfaceIdiom == .pad {
            padding = 8
        }
        
//        contentView.addSubview(imageView)
        contentView.addSubview(containerView)
        containerView.addSubview(bgImageView)
        // Add subviews to the cell
        containerView.addSubview(imageView)
        containerView.addSubview(lockImageView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        // Enable Auto Layout
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            
            bgImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding+3),
            bgImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            bgImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            bgImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding+3),
            bgImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -(padding+3)),
            bgImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -(padding+3)),
            
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            
            lockImageView.widthAnchor.constraint(equalToConstant: cellsize),
            lockImageView.heightAnchor.constraint(equalToConstant: cellsize),
            lockImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            lockImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
        ])
    }
    
    func configure(with image: UIImage, isLocked: Bool) {
        imageView.image = image
        lockImageView.isHidden = !isLocked
    }
}
