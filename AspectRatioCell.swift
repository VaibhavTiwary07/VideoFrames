//
//  AspectRatioCell.swift
//  StickerView
//
//  Created by apple on 24/01/25.
//

import Foundation
import UIKit



@objcMembers
class AspectRatioCell: UICollectionViewCell {
    static let identifier = "AspectRatioCell"
    let offset : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 15 : 0
    let multiplier : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 0.85 : 0.75
    private let ContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stickerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit //.scaleToFill //
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let stickerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Gilroy-Medium", size: 14) //UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isSelected: Bool {
            didSet {
                //stickerImageView.tintColor = isSelected ? UIColor.systemCyan : UIColor.lightGray
                stickerImageView.clipsToBounds = true
                stickerImageView.layer.borderColor = isSelected ? UIColor.systemCyan.cgColor:UIColor.clear.cgColor
                stickerImageView.layer.borderWidth = 3
                
                if(isSelected)
                {
                    imageTapped();
                }
            }
    }
    
    func imageTapped() {
           // Shrink effect
           UIView.animate(withDuration: 0.15, animations: {
               self.stickerImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
           }) { _ in
               // Bounce back to original size
               UIView.animate(withDuration: 0.15, animations: {
                   self.stickerImageView.transform = .identity
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
        ContainerView.addSubview(stickerImageView)
        ContainerView.addSubview(stickerLabel)
        
        
        // Layout constraints
        NSLayoutConstraint.activate([
            
            ContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            ContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            // ImageView constraints
 //           stickerImageView.topAnchor.constraint(equalTo: ContainerView.topAnchor, constant: 35),
            stickerImageView.centerXAnchor.constraint(equalTo: ContainerView.centerXAnchor,constant: 0),
            stickerImageView.centerYAnchor.constraint(equalTo: ContainerView.centerYAnchor,constant: 0),
//            stickerImageView.leadingAnchor.constraint(equalTo: ContainerView.leadingAnchor, constant: 10),
//            stickerImageView.trailingAnchor.constraint(equalTo: ContainerView.trailingAnchor, constant: -10),
 //           stickerImageView.bottomAnchor.constraint(equalTo: ContainerView.bottomAnchor, constant: -55),
            stickerImageView.widthAnchor.constraint(equalTo: ContainerView.widthAnchor, multiplier: 0.75), // 50% of container width
            stickerImageView.heightAnchor.constraint(equalTo: stickerImageView.widthAnchor),
            
            // Label constraints
            stickerLabel.topAnchor.constraint(equalTo: stickerImageView.bottomAnchor, constant: 0),
            stickerLabel.leadingAnchor.constraint(equalTo: stickerImageView.leadingAnchor, constant: 0),
            stickerLabel.trailingAnchor.constraint(equalTo: stickerImageView.trailingAnchor, constant: 0),
            stickerLabel.bottomAnchor.constraint(equalTo: ContainerView.bottomAnchor, constant: -offset)
        ])
    }
    
    func configure(with sticker: Sticker) {
        stickerLabel.text = sticker.name
        print("width height",UIImage(named: sticker.imageName)!.size.width,UIImage(named: sticker.imageName)!.size.height)
        stickerImageView.image = UIImage(named: sticker.imageName)?.withRenderingMode(.alwaysOriginal)
        //stickerImageView.tintColor = .lightGray
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
