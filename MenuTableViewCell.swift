//
//  MenuTableViewCell.swift
//  AudioVideoMixer
//
//  Created by Sachin on 16/05/24.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    var menuLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(red: 40/255, green: 70/255, blue: 130/255, alpha: 1.0)
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let menuImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.tintColor =  UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0)
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(menuLabel)
        contentView.addSubview(menuImageView)
        
        menuImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        menuImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        menuImageView.widthAnchor.constraint(equalToConstant: 33).isActive = true
        menuImageView.heightAnchor.constraint(equalToConstant: 33).isActive = true
        
        menuLabel.centerYAnchor.constraint(equalTo: menuImageView.centerYAnchor).isActive = true
        menuLabel.leadingAnchor.constraint(equalTo: menuImageView.trailingAnchor, constant: 10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
