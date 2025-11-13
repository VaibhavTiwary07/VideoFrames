//
//  MenuTableViewHeader.swift
//  AudioVideoMixer
//
//  Created by Sachin on 16/05/24.
//

import UIKit

class MenuTableViewHeader: UITableViewHeaderFooterView {

    var appImageView: UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "ItunesArtwork")
        //imgV.layer.cornerRadius = 50
        imgV.clipsToBounds = true
        imgV.translatesAutoresizingMaskIntoConstraints = false
        imgV.layer.borderWidth = 2.0
        imgV.layer.borderColor = UIColor.white.cgColor

        return imgV
    }()
    
    var menuTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(red: 40/255, green: 70/255, blue: 130/255, alpha: 1.0)
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        lbl.text = "Video Collage"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(appImageView)
        contentView.addSubview(menuTitleLabel)
        
        appImageView.layer.cornerRadius = 10
        
        appImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        appImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        appImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        appImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
      
        menuTitleLabel.centerXAnchor.constraint(equalTo: appImageView.centerXAnchor).isActive = true
        menuTitleLabel.topAnchor.constraint(equalTo: appImageView.bottomAnchor, constant: 15).isActive = true
        
        menuTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    
}
