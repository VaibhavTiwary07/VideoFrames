//
//  MainCollectionViewCell.swift
//  VideoFrames
//
//  Created by apple on 17/02/25.
//

import Foundation
class MainCollectionViewCell: UICollectionViewCell {
    
    var stickerCollectionView: UICollectionView!
    var stickers: [String] = []
    
    func updateLayout() {
        stickerCollectionView.collectionViewLayout.invalidateLayout()
        
    }

    func configure(with category: StickerCategory) {
//        for i in 0...category.count {
//            let stickerName  = category.prefix+String(i)
//            print("Sticker name is ",stickerName)
//            self.stickers.append(stickerName)
//        }
//        print("sticker count --------",self.stickers.count,category.count)
        self.stickers = category.stickers //stickerNames
        stickerCollectionView.reloadData() // Reload the nested collection view
       }
       
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        let stickerLayout = UICollectionViewFlowLayout()
        let sizeOfItem: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 100 : 75
        stickerLayout.itemSize = CGSize(width: sizeOfItem, height: sizeOfItem) // Size of each item
        stickerLayout.minimumInteritemSpacing = 10 // Spacing between items horizontally
        stickerLayout.minimumLineSpacing = 10 // Spacing between items vertically
        stickerLayout.scrollDirection = .vertical // The direction in which items will scroll
        stickerLayout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        
        stickerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: stickerLayout)
        stickerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        let user_default_color =  UIColor(red:28/255.0, green:32/255.0 , blue:38/255.0, alpha:1.0)
        stickerCollectionView.backgroundColor = .clear//user_default_color //UIColor(hue: 0.0, saturation: 0.0, brightness: 0.18, alpha: 1.0)
        stickerCollectionView.dataSource = self
        stickerCollectionView.delegate = self
        stickerCollectionView.register(StickerCollectionViewCell.self, forCellWithReuseIdentifier: StickerCollectionViewCell.identifier)
        stickerCollectionView.layer.cornerRadius = 5
        stickerCollectionView.tag = 1
        stickerCollectionView.showsVerticalScrollIndicator = false
        
        contentView.addSubview(stickerCollectionView)
        
        stickerCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        stickerCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stickerCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stickerCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // Implement the data source and delegate methods for the stickerCollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stickers.count // Adjust the number of stickers for this cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSticker = stickers[indexPath.row] // Access the stickers array
              
              // Notify the parent view controller (StickerViewController)
              if let parentVC = self.parentViewController as? StickerViewController {
                  parentVC.didSelectSticker(selectedSticker)
                  
              }
        
          }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StickerCollectionViewCell.identifier, for: indexPath) as! StickerCollectionViewCell
        
        let stickerName = stickers[indexPath.row]
//        if(stickerName .contains("heart") )//|| stickerName .contains("friendship"))
//        {
//            if let path = Bundle.main.path(forResource: stickerName, ofType: "webp"),
//               let imageData = try? Data(contentsOf: URL(fileURLWithPath: path)),
//               let webpImage = UIImage(data: imageData) {
//                cell.imageView.image = webpImage
//            }
//        }
//        else
//        {
//            cell.imageView.image = UIImage(named: stickerName)
//        }
        cell.imageView.image = UIImage(named: stickerName)
        // Configure the sticker cell
        return cell
    }
    
    
}
