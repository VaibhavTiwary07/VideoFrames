//
//  TypeBGCell.swift
//  VideoFrames
//
//  Created by apple on 30/01/25.
//

import Foundation
import UIKit

class TypeBGCell: UICollectionViewCell {
    static let identifier = "TypeBGCell"
    
    weak var delegate: TypeBGDelegate?

    @IBOutlet weak var myButton: UIButton!

    @IBAction func buttonTapped(_ sender: UIButton) {
        delegate?.didTapButton(in: self)
    }
    
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
    
    //    // Add a label
    //    private let label: UILabel = {
    //        let label = UILabel()
    //        label.textAlignment = .center
    //        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
    //        label.textColor = .white
    //        return label
    //    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(containerView)
        containerView.addSubview(bgImageView)
        // Add subviews to the cell
        containerView.addSubview(imageView)
        // contentView.addSubview(label)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        // Enable Auto Layout
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // label.translatesAutoresizingMaskIntoConstraints = false
        var padding:CGFloat = 3
        if UIDevice.current.userInterfaceIdiom == .pad {
            padding = 5
        }
        // Set constraints for image view and label
        NSLayoutConstraint.activate([
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
//            imageView.widthAnchor.constraint(equalToConstant: 75),
//            imageView.heightAnchor.constraint(equalToConstant: 75),
            
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
    func configure(imageName: String) //(text: String)
    {
       // let redImage = UIImage.from(color: .red, size: CGSize(width: 100, height: 100))
        imageView.image = UIImage(named: imageName)
        // label.text = text
    }
    
    override var isSelected: Bool {
       didSet {
           print("is selected typebgcell")
           //containerView.backgroundColor = isSelected ? UIColor.systemCyan : UIColor.clear
           imageView.layer.borderWidth = 5
                imageView.layer.borderColor = isSelected ? UIColor.systemCyan.cgColor : UIColor.clear.cgColor
           if(isSelected) {imageTapped()}
            }
    }
    
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
    
}
    protocol TypeBGDelegate: AnyObject {
        func didTapButton(in cell: TypeBGCell)
    }

// UNUSED:
/*
extension UIImage {
    static func from(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}
*/
