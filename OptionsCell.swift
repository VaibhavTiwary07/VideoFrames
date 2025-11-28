//
//  OptionsCell.swift
//  VideoFrames
//
//  Created by apple on 25/03/25.
//

import Foundation
import UIKit



@objcMembers
class OptionsCell: UICollectionViewCell {
    static let identifier = "OptionsCell"
    let customColor = UIColor(red: 184.0/255.0, green: 234.0/255.0, blue: 112.0/255.0, alpha: 1.0)
    let offset : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 15 : -8
    let multiplier : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 0.85 : 0.75
    let topAnchorConstant : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 12 : 3
    private let ContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let optionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let optionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Gilroy-Medium", size: (UIDevice.current.userInterfaceIdiom == .pad) ? 14 : 12)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var selected_Image : UIImage?
    var init_Image : UIImage?
    
    override var isSelected: Bool {
            didSet {
//                //optionImageView.tintColor = isSelected ? UIColor.systemCyan : UIColor.lightGray
//                optionImageView.clipsToBounds = true
//                optionImageView.layer.borderColor = isSelected ? UIColor.systemCyan.cgColor:UIColor.clear.cgColor
//                optionImageView.layer.borderWidth = 3
//                
                if(isSelected)
                {
                    optionImageView.image = selected_Image
                    optionLabel.textColor = customColor
//                    imageTapped();
                }else
                {
                    optionImageView.image = init_Image
                    optionLabel.textColor = .white
                    
                }
            }
    }
    
    func imageTapped() {
           // Shrink effect
           UIView.animate(withDuration: 0.15, animations: {
               self.optionImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
           }) { _ in
               // Bounce back to original size
               UIView.animate(withDuration: 0.15, animations: {
                   self.optionImageView.transform = .identity
               })
           }
       }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(ContainerView)
        ContainerView.addSubview(optionImageView)
        ContainerView.addSubview(optionLabel)
        
        
        // Layout constraints
        NSLayoutConstraint.activate([
            
            ContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            ContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            optionImageView.topAnchor.constraint(equalTo: ContainerView.topAnchor,constant: topAnchorConstant),
            optionImageView.centerXAnchor.constraint(equalTo: ContainerView.centerXAnchor,constant: 0),
           // optionImageView.centerYAnchor.constraint(equalTo: ContainerView.centerYAnchor,constant: 0),

            // Label constraints
            optionLabel.topAnchor.constraint(equalTo: optionImageView.bottomAnchor, constant: 8),
            optionLabel.leadingAnchor.constraint(equalTo: optionImageView.leadingAnchor, constant: 0),
            optionLabel.trailingAnchor.constraint(equalTo: optionImageView.trailingAnchor, constant: 0)
           // optionLabel.bottomAnchor.constraint(equalTo: ContainerView.bottomAnchor, constant: -offset)
        ])
    }
    
    func configure(with option:Option) {
        optionLabel.text = option.name
        print("width height",option.image.size.width,option.image.size.height)
        optionImageView.image = option.image
        selected_Image = option.selectedImage
        init_Image = option.image
    }
    
    func addBorderToImageView(_ imageView: UIImageView) {
            guard let image = imageView.image else { return }

            let imageSize = image.size
            let imageViewSize = imageView.bounds.size

            let scaleX = imageViewSize.width / imageSize.width
            let scaleY = imageViewSize.height / imageSize.height
            let scale = min(scaleX, scaleY)

            let newWidth = imageSize.width * scale
            let newHeight = imageSize.height * scale

            let borderFrame = CGRect(
                x: (imageViewSize.width - newWidth) / 2,
                y: (imageViewSize.height - newHeight) / 2,
                width: newWidth,
                height: newHeight
            )

            let borderLayer = CAShapeLayer()
            borderLayer.path = UIBezierPath(rect: borderFrame).cgPath
            borderLayer.strokeColor = UIColor.systemCyan.cgColor
            borderLayer.lineWidth = 2
            borderLayer.fillColor = UIColor.clear.cgColor

            imageView.layer.addSublayer(borderLayer)
        }
    
}
