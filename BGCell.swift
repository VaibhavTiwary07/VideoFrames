//
//  BGCell.swift
//  VideoFrames
//
//  Created by apple on 30/01/25.
//


import Foundation
import UIKit

@objcMembers class BGCell: UICollectionViewCell {
    static let identifier = "BGCell"
    let screenHeight : CGFloat = UIScreen.main.bounds.height
  //  let cellsize : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 60 : UIScreen.main.bounds.height*0.06
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        imageView.layer.shadowRadius = 6
     //   imageView.layer.cornerRadius = (UIDevice.current.userInterfaceIdiom == .pad) ? 30 : UIScreen.main.bounds.height*0.03;
        return imageView
    }()
    
//    // Add a label
//    private let label: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
//        label.textColor = .white
//        return label
//    }()
    
    func isiPod() -> Bool {
        let device = UIDevice.current
        return device.userInterfaceIdiom == .phone && UIScreen.main.bounds.height == 568
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add subviews to the cell
        contentView.addSubview(imageView)
       // contentView.addSubview(label)
        
        // Enable Auto Layout
        imageView.translatesAutoresizingMaskIntoConstraints = false
       // label.translatesAutoresizingMaskIntoConstraints = false

        if (isiPod())
        {
            imageView.layer.cornerRadius = 20
        }
        else
        {
            imageView.layer.cornerRadius = (UIDevice.current.userInterfaceIdiom == .pad) ? 30 : UIScreen.main.bounds.height*0.03;
        }
        // Set constraints for image view and label
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
//            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            imageView.widthAnchor.constraint(equalToConstant: cellsize),
//            imageView.heightAnchor.constraint(equalToConstant: cellsize),
            
//            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
//            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
//            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
//            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Configure the cell with data
    func configure(color:UIColor)//(imageName: String) //(text: String)
    {
        imageView.image = imageFromColor(color: color, size: CGSize(width: 320, height: 320))//UIImage(named: imageName)
       // label.text = text
        
//        imageView.layer.borderWidth = 3
//        imageView.layer.borderColor =  UIColor.gray.cgColor
    }
    
    func configure(imageName: String) //(text: String)
    {
        imageView.image = UIImage(named: imageName)
       // label.text = text
        
//        imageView.layer.borderWidth = 3
//        imageView.layer.borderColor =  UIColor.gray.cgColor
    }
    
    override var isSelected: Bool {
            didSet {
                imageView.layer.borderWidth = 3
                imageView.layer.borderColor = isSelected ? UIColor.systemCyan.cgColor : UIColor.clear.cgColor
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
    
    
    func imageFromColor(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        color.setFill()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
