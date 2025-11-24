//
//  OptionsViewController.swift
//  VideoFrames
//
//  Created by apple on 25/03/25.

import Foundation
import UIKit

class OptionsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    var optionsList: [Option] = []
    let screenWidth : CGFloat  = UIScreen.main.bounds.width
    // UNUSED: let screenHeight : CGFloat = UIScreen.main.bounds.height
    // UNUSED: let offset : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 10 : 5
    let topAnchorConstant : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 12 : 8
    let viewHeight : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 90 : 70

    private func loadData() {
    
        // Apply custom RGB color
        let customColor = UIColor(red: 25.0/255.0, green: 184.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        
        
        optionsList.append( Option(name: "Frames", image: UIImage(named: "frames2")!, selectedImage: UIImage(named: "frames_active2")!))
        
        optionsList.append(  Option(name: "Ratio", image: UIImage(named: "Ratio")!, selectedImage: UIImage(named: "Ratio_active")!))
        
        optionsList.append(Option(name: "Background", image: UIImage(named: "colors2")!, selectedImage: UIImage(named: "colors_active2")!))
        
        optionsList.append( Option(name: "Adjust", image: UIImage(named: "adjust2")!, selectedImage: UIImage(named: "adjust_active2")!))
        
        optionsList.append(  Option(name: "Effects", image: UIImage(named: "fx2")!, selectedImage: UIImage(named: "fx_active2")!))
        
        optionsList.append(  Option(name: "Music", image: UIImage(named: "music2")!, selectedImage: UIImage(named: "music_active2")!))
        
        
        
        
        
        if let systemImage = UIImage(systemName: "face.smiling", withConfiguration: config) {
            
            let whiteFaceTintedImage = systemImage.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)

            let selectedFaceTintedImage = systemImage.withTintColor(customColor, renderingMode: .alwaysOriginal)
            optionsList.append(Option(name: "Stickers", image:whiteFaceTintedImage, selectedImage: selectedFaceTintedImage))
        }
        
        if let systemImage = UIImage(systemName: "textformat.size", withConfiguration: config) {
            
            let whiteTextTintedImage = systemImage.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)

            let selectedTextTintedImage = systemImage.withTintColor(customColor, renderingMode: .alwaysOriginal)
            optionsList.append(Option(name: "Text", image:whiteTextTintedImage, selectedImage:selectedTextTintedImage ))
        }
        
    }
    
    
    
    // UNUSED:
    /*
    var selectedCategoryIndex: Int = 0 {
        didSet {
            optionsCollectionView.reloadData()
            print("new index selected")
        }
    }
    */
    
    var optionsLayout:UICollectionViewFlowLayout!

    private var optionsCollectionView: UICollectionView!

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("--- OptionsViewController.swift: viewDidLoad ---")
        let user_default_color =  UIColor(red:28/255.0, green:32/255.0 , blue:38/255.0, alpha:1.0)
        view.backgroundColor = user_default_color
        view.layer.cornerRadius = 20
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotification(_:)),
                                               name: NSNotification.Name("resetSelectedItems"),
                                               object: nil)
        loadData()
        setupCollectionViews()
        
    }
    
    
     @objc func AnimateView() {

        guard let collectionView = optionsCollectionView else { return }

        let smallOffset: CGFloat = 30 // Adjust for subtlety

        UIView.animate(withDuration: 0.6, delay: 0.2, options: [.curveEaseInOut]) {
            collectionView.contentOffset.x += smallOffset
        } completion: { _ in
            UIView.animate(withDuration: 0.6, delay: 0.2, options: [.curveEaseInOut]) {
                collectionView.contentOffset.x -= smallOffset
            }
        }
        print("collection view Animating")
    }
    
    @objc func handleNotification(_ notification: Notification) {
//        if let userInfo = notification.userInfo {
//            print("Received notification with info: \(userInfo)")
//        }
        resetAllSelectedOptions()
    }

    func resetAllSelectedOptions()
    {
        if let selectedIndexPaths = optionsCollectionView.indexPathsForSelectedItems {
            for indexPath in selectedIndexPaths {
                optionsCollectionView.deselectItem(at: indexPath, animated: true)
            }
        }
    }
    
    
    // MARK: - Setup Methods
    private func setupCollectionViews() {
        
        
        optionsLayout = UICollectionViewFlowLayout()
        optionsLayout.scrollDirection = .horizontal
      //  optionsLayout.minimumLineSpacing = 10
      //  optionsLayout.minimumInteritemSpacing = 10
        
        optionsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: optionsLayout)
        optionsCollectionView.isPagingEnabled = false
        optionsCollectionView.backgroundColor = .clear
        optionsCollectionView.register(OptionsCell.self, forCellWithReuseIdentifier:OptionsCell.identifier)
    
        
        optionsCollectionView.delegate = self
        optionsCollectionView.dataSource = self
        optionsCollectionView.backgroundColor = .clear;
        view.addSubview(optionsCollectionView)
        optionsCollectionView.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            optionsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            optionsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            optionsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: topAnchorConstant),
           // optionsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -offset),
            optionsCollectionView.heightAnchor.constraint(equalToConstant: viewHeight)
        ])
    }
    
    
    
    // MARK: - UICollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return optionsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionsCell.identifier, for: indexPath) as! OptionsCell
        if indexPath.item < optionsList.count {
            cell.configure(with: optionsList[indexPath.item])
        }
            return cell
    }
    
    // MARK: - UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item >= 0 && indexPath.item < optionsList.count else {
                print("Index \(indexPath.item) is out of bounds for optionsList count: \(optionsList.count)")
                return
            }
            
        let selectedOption = optionsList[indexPath.item]
            // Define a constant for the notification name
            let myNotificationName = Notification.Name("optionselected")
            let params: [String: Any] = ["option": selectedOption.name]
            NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: params)
      
    }

    
    func isiPod() -> Bool {
        let device = UIDevice.current
        return device.userInterfaceIdiom == .phone && UIScreen.main.bounds.height == 568
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        print("available width",collectionView.bounds.width)
        
        var numofitemsforScreen = 6
        var reminder : CGFloat = 0
        if((UIDevice.current.userInterfaceIdiom == .pad))
        {
            let possiblenumItems = Int(screenWidth / collectionView.bounds.height)
            print(" possible items num ",possiblenumItems)
            if(possiblenumItems >= 8)
            {
                numofitemsforScreen = 8
                reminder = 0
            }
            else
            {
                numofitemsforScreen = possiblenumItems
                reminder = 0.6
            }
        }
        else if(isiPod())
        {
            let possiblenumItems = Int(screenWidth / collectionView.bounds.height)
            print(" ipod possible items num ",possiblenumItems)
            reminder = 0.65
            numofitemsforScreen = 4
        }
        else
        {
            let possiblenumItems = Int(screenWidth / collectionView.bounds.height)
            print(" iphone possible items num ",possiblenumItems)
            if(possiblenumItems > 5)
            {
                numofitemsforScreen = 5
            }else
            {
                numofitemsforScreen = 4
            }
            reminder = 0.6
            
        }
        let spacing = 8
        let availableWidthforscreen : CGFloat = screenWidth - 10 - CGFloat((numofitemsforScreen * spacing))
        let itemwidth = availableWidthforscreen / (CGFloat(numofitemsforScreen) + reminder)
        print("item width is ",itemwidth)
        
        return CGSize(width: itemwidth, height: collectionView.bounds.height - 10)
        
//        if((UIDevice.current.userInterfaceIdiom == .pad))
//        {
//            return CGSize(width: 100, height: 100)
//        }
//        else if(isiPod())
//        {
//            return CGSize(width: 58, height: 60)
//        }
//        else{
//            return CGSize(width: 70, height: 60)
//        }
    }
    
    

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//    }
 
}
