//
//  BackgroundSelectionViewController.swift
//  VideoFrames
//
//  Created by apple on 30/01/25.
//

import Foundation
import UIKit

class BackgroundSelectionViewController:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TypeBGDelegate,UIColorPickerViewControllerDelegate,PHPickerViewControllerDelegate
{
    
    var typeBg : [TypeBG] = []
    var hexIntegers:[Int32] = [
        0xFFFFFF ,
                   0xD8A7A7 , // Red
                   0xF2D9B3 , // Green
                   0xD6DB81 , // Blue
                   0xC2DE95 , // Yellow
                   0x97DF7A , // Cyan
                   0x92E1AD , // Magenta
                   0x8DE3E5 , // Orange
                   0x96B9EA  ,
                   0xF4F9FF ,
                   0xE0F7FA ,
                   0xFFEBEE ,
                   0xFFFDE7 ,
                   0xFFF3E0 ,
                   0xF3E5F5 ,
                   0xE8F5E9 ,
                   0xF0F4C3 ,
                   0xFFECB3
                    ,0xFFE0B2 ,
                   0xE1F5FE ,
                   0xEDE7F6 ,
                   0xF8BBD0 ,
                   0xFFCDD2 ,
                   0xDCEDC8 ,
                   0xFFCCBC ,
                   0xFFF9C4 ,
                   0xF5F5F5 ,
                   0xFFEB3B ,
                   0xE1BEE7 ,
                   0xC8E6C9 ,
                   0xFFCC80 ,
                   0xFFAB91 ,
                   0xD1C4E9 ,
                   0xB3E5FC ,
                   0xF1F8E9 ,
                   0xD7CCC8 ,
                   0xFBE9E7 ,
                   0xFCE4EC ,
                   0xB2DFDB ,
                   0x000000 , // Black
                   0xFF0000 , // Red
                   0x00FF00 , // Green
                   0x0000FF , // Blue
                   0xFFFF00 , // Yellow
                   0x00FFFF , // Cyan
                   0xFF00FF , // Magenta
                   0xFFA500 , // Orange
                   0x800080 ,
    ]
    var verySmall :UISheetPresentationController.Detent = .medium()
    var small :UISheetPresentationController.Detent = .medium()
     var heightConstraint: NSLayoutConstraint?
    let screenWidth : CGFloat  = UIScreen.main.bounds.width
    let screenHeight : CGFloat = UIScreen.main.bounds.height
    let small_DetentHeight : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? (UIScreen.main.bounds.height * 0.25) : (UIScreen.main.bounds.height * 0.25)
    let verySmall_DetentHeight : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? (UIScreen.main.bounds.height * 0.15) : (UIScreen.main.bounds.height * 0.18)
    var heightOfTitleBar : CGFloat = 60
    let heightConstant : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 80 : UIScreen.main.bounds.height*0.075
    let offset : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 10 : 5
    let cellsize : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 60 : UIScreen.main.bounds.height*0.06
    var initialBounds: CGRect?
//    var topView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .clear //UIColor(red: 48.0/255.0, green: 51.0/255.0, blue: 58.0/255.0, alpha: 1.0)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        // Add shadow for 3D effect
//        view.layer.shadowColor = UIColor.white.cgColor
//        view.layer.shadowOpacity = 0.3
//        view.layer.shadowOffset = CGSize(width: 0, height: 3)
//        view.layer.shadowRadius = 8
//       // view.layer.cornerRadius = 8  // Subtle corner radius
//        return view
//    }()
    
    var topView: ShadowContainerView = {
        let view = ShadowContainerView()
        let user_default_color =  UIColor(red:28/255.0, green:32/255.0 , blue:38/255.0, alpha:1.0)
        view.backgroundColor = user_default_color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Add a label
    private let titlLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Gilroy-Medium", size: (UIDevice.current.userInterfaceIdiom == .pad) ? 20 : 15)//UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    var doneButton: UIButton = {
        let btn = UIButton()
        btn.tintColor = .white
        btn.backgroundColor = .clear
        btn.setImage(UIImage(named: "done2")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.isUserInteractionEnabled = true
        btn.imageView?.contentMode = .scaleAspectFit
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var lineView: UIView = {
        let view = UIView()
        let color = UIColor(red: 48.0/255.0, green: 51.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        view.backgroundColor = color  //UIColor(red: 48.0/255.0, green: 51.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        // Add shadow for 3D effect
//        view.layer.shadowColor = UIColor.white.cgColor
//        view.layer.shadowOpacity = 1
//        view.layer.shadowOffset = CGSize(width: 0, height: 3)
//        view.layer.shadowRadius = 8
        return view
    }()
    var availableBGLayout:UICollectionViewFlowLayout!
    private var  availableBGCollectionView: UICollectionView!
//    = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.itemSize = CGSize(width: 60, height: 60)
//        layout.minimumLineSpacing = 10
//        layout.minimumInteritemSpacing = 20
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = .clear
//        return collectionView
//    }()
    
    var line_View: UIView = {
        let view = UIView()
        let color = UIColor(red: 48.0/255.0, green: 51.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        view.backgroundColor = color  //UIColor(red: 48.0/255.0, green: 51.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        // Add shadow for 3D effect
//        view.layer.shadowColor = UIColor.white.cgColor
//        view.layer.shadowOpacity = 1
//        view.layer.shadowOffset = CGSize(width: 0, height: 3)
//        view.layer.shadowRadius = 8
        return view
    }()
    
    var bgViewForTypeBG: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var typeOfBGLayout:UICollectionViewFlowLayout!

    var typeOfBGCollectionView: UICollectionView!
//    = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontaly
//        layout.itemSize = CGSize(width: 50, height: 50)
//        if .isiPod()
//        {
//            layout.minimumLineSpacing = 5
//            layout.minimumInteritemSpacing = 5
//        }else
//        {
//            layout.minimumLineSpacing = 20
//            layout.minimumInteritemSpacing = 5
//        }
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        let color = UIColor(red: 48.0/255.0, green: 51.0/255.0, blue: 58.0/255.0, alpha: 1.0)
//        collectionView.backgroundColor = color //.systemGray
//        return collectionView
//    }()
    
    var selectedTypeIndex: Int = 0 {
        didSet {
            availableBGCollectionView.reloadData()
            print("new index selected")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if((UIDevice.current.userInterfaceIdiom == .pad) )
        {
            heightOfTitleBar = 60
        }
        else if(isiPod())
        {
            heightOfTitleBar = 35
        }
        else
        {
            heightOfTitleBar = UIScreen.main.bounds.height*0.05
        }
       let user_default_color =  UIColor(red:28/255.0, green:32/255.0 , blue:38/255.0, alpha:1.0)
        let color = UIColor(red: 48.0/255.0, green: 51.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        view.backgroundColor = user_default_color
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
//        view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
//        view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        if #available(iOS 16.0, *) {
            self.verySmall = UISheetPresentationController.Detent.custom { context in
                return self.verySmall_DetentHeight
//                if UIDevice.current.userInterfaceIdiom == .pad {
//                    return self.screenHeight * 0.3 //135 // Height in points for your custom detent
//                }else {
//                    return self.screenHeight * 0.2 //135
//                }
            }
            self.small = UISheetPresentationController.Detent.custom { context in
                return self.small_DetentHeight
//                if UIDevice.current.userInterfaceIdiom == .pad {
//                    return self.screenHeight * 0.35 // Height in points for your custom detent
//                }else {
//                    return self.screenHeight * 0.25 //135
//                }
            }
        } else {
            // Fallback on earlier versions
            self.verySmall = UISheetPresentationController.Detent.medium()
            self.small = UISheetPresentationController.Detent.medium()
        }
        loadData()
        setupCollectionViews()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        pulseCount = 0  // Reset counter when the view appears
//            animateScrollPulse()
//    }
//
//    private var pulseCount = 0
//
//    private func animateScrollPulse() {
//        guard typeOfBGCollectionView.contentSize.width > typeOfBGCollectionView.frame.width else { return }
//
//        if pulseCount >= 2 {
//            pulseCount = 0
//            return
//        }
//
//        pulseCount += 1
//
//        let scrollOffset: CGFloat = 100
//        let initialOffset = typeOfBGCollectionView.contentOffset
//
//        // Use UIView.animate for easing + UIView.animateKeyframes for keyframe animation
//        UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseInOut) {
//            UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: [.calculationModePaced]) {
//                
//                // Scroll right
//                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.4) {
//                    self.typeOfBGCollectionView.setContentOffset(CGPoint(x: initialOffset.x + scrollOffset, y: initialOffset.y), animated: false)
//                }
//
//                // Scroll back
//                UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.4) {
//                    self.typeOfBGCollectionView.setContentOffset(initialOffset, animated: false)
//                }
//            }
//        } completion: { _ in
//            self.animateScrollPulse()  // Repeat animation 2 times
//        }
//    }
    
    func didTapButton(in cell: TypeBGCell) {
        if let indexPath = typeOfBGCollectionView.indexPath(for: cell) {
            print("Button tapped in cell at index: \(indexPath.row)")
            
        }
    }
    
    
    func imageFromColor(_ color: UIColor, size: CGSize = CGSize(width: 100, height: 100)) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
    
    func loadData()
    {
        let imageSize = CGSize(width: 300, height: 300)
        typeBg.append(TypeBG(name: "Gallery", imageName: "Gallery", colors: [], bgImages: []))
        typeBg.append(TypeBG(name: "ColorPicker", imageName: "colors", colors: [],bgImages: []))
        typeBg.append(TypeBG(name: "WhiteColor", imageName: "white", colors: [],bgImages: [imageFromColor(UIColor.white, size: imageSize)]))
        
        
        var pastalColors : [UIColor] = []
        var pastalImages : [UIImage] = []
        for g in 0...47
        {
            pastalColors.append(GridView.getColorFromHex(at: hexIntegers[g]))
            pastalImages.append(imageFromColor(GridView.getColorFromHex(at: hexIntegers[g]), size: imageSize))
        }
//        var solidcolors :[UIColor] = []
//        for i in 0...52 {
//            solidcolors.append(GridView.getColorAt(Int32(i)))
//        }
        
        typeBg.append(TypeBG(name: "SolidColors", imageName: "solid", colors: pastalColors, bgImages: pastalImages))
        
        var patternColors:[UIColor] = []
        var patternImages:[UIImage] = []
        for j in 0...41 {
            patternColors.append(GridView.getPatternAt(Int32(j)))
            patternImages.append(GridView.getPatternImage(at: Int32(j)))
        }
        typeBg.append(TypeBG(name: "Patterns", imageName: "pattern", colors: patternColors,bgImages:patternImages))
       
        
        
        var gradientColors:[UIColor] = []
        var gradientImages:[UIImage] = []
        for k in 0...20 {
            gradientColors.append(GridView.getColorOfImage(at: Int32(k), imagePrefix: "Gradients_"))
            gradientImages.append(GridView.getImageAt(Int32(k), imagePrefix: "Gradients_"))
        }
        typeBg.append(TypeBG(name: "Gradients", imageName: "gradients", colors:gradientColors,bgImages: gradientImages))
        
        var flowerColors:[UIColor] = []
        var flowerImages:[UIImage] = []
        for l in 0...9 {
            flowerColors.append(GridView.getColorOfImage(at: Int32(l), imagePrefix: "flower_"));
            flowerImages.append(GridView.getImageAt( Int32(l), imagePrefix: "flower_"));
        }
        typeBg.append(TypeBG(name: "Flowers", imageName: "flowers", colors:flowerColors,bgImages: flowerImages))
        
        
        var birthdayColors:[UIColor] = []
        var birthdayImages:[UIImage] = []
        for m in 0...10 {
            birthdayColors.append(GridView.getColorOfImage(at:Int32(m), imagePrefix:"birthday_"));
            birthdayImages.append(GridView.getImageAt(Int32(m), imagePrefix:"birthday_"));
        }
        typeBg.append(TypeBG(name: "Birthday", imageName: "birthday", colors:birthdayColors,bgImages: birthdayImages))

        
        var autumnColors:[UIColor] = []
        var autumnImages:[UIImage] = []
        for m in 0...8 {
            autumnColors.append(GridView.getColorOfImage(at:Int32(m), imagePrefix:"autumn_"));
            autumnImages.append(GridView.getImageAt(Int32(m), imagePrefix:"autumn_"));
        }
        typeBg.append(TypeBG(name: "Autumn", imageName: "autumn", colors:autumnColors,bgImages:autumnImages))

        var christmasColors:[UIColor] = []
        var christmasImages:[UIImage] = []
        for m in 0...9 {
            christmasColors.append(GridView.getColorOfImage(at:Int32(m), imagePrefix:"christmas_"));
            christmasImages.append(GridView.getImageAt(Int32(m), imagePrefix:"christmas_"));
        }
        typeBg.append(TypeBG(name: "Christmas", imageName: "christmas", colors:christmasColors,bgImages:christmasImages))

        var diwaliColors:[UIColor] = []
        var diwaliImages:[UIImage] = []
        for m in 0...9 {
            diwaliColors.append(GridView.getColorOfImage(at:Int32(m), imagePrefix:"diwali_"));
            diwaliImages.append(GridView.getImageAt(Int32(m), imagePrefix:"diwali_"));
        }
        typeBg.append(TypeBG(name: "Diwali", imageName: "diwali", colors:diwaliColors,bgImages:diwaliImages))

        
        var cloudColors:[UIColor] = []
        var cloudImages:[UIImage] = []
        for m in 0...9 {
            cloudColors.append(GridView.getColorOfImage(at:Int32(m), imagePrefix:"cloud_"));
            cloudImages.append(GridView.getImageAt(Int32(m), imagePrefix:"cloud_"));

        }
        typeBg.append(TypeBG(name: "Cloud", imageName: "cloudCategory", colors:cloudColors,bgImages:cloudImages))

        
        var cuteColors:[UIColor] = []
        var cuteImages:[UIImage] = []
        for m in 0...9 {
            cuteColors.append(GridView.getColorOfImage(at:Int32(m), imagePrefix:"cute_"));
            cuteImages.append(GridView.getImageAt(Int32(m), imagePrefix:"cute_"));

        }
        typeBg.append(TypeBG(name: "Cute", imageName: "cute", colors:cuteColors, bgImages:cuteImages))

        
        var emojiColors:[UIColor] = []
        var emojiImages:[UIImage] = []
        for m in 0...9 {
            emojiColors.append(GridView.getColorOfImage(at:Int32(m), imagePrefix:"emoji_"));
            emojiImages.append(GridView.getImageAt(Int32(m), imagePrefix:"emoji_"));
        }
        typeBg.append(TypeBG(name: "Emoji", imageName: "emoji", colors:emojiColors, bgImages:emojiImages))

        var fireworksColors:[UIColor] = []
        var fireworksImages:[UIImage] = []
        for m in 0...9 {
            fireworksColors.append(GridView.getColorOfImage(at:Int32(m), imagePrefix:"fireworks_"));
            fireworksImages.append(GridView.getImageAt(Int32(m), imagePrefix:"fireworks_"));
        }
        typeBg.append(TypeBG(name: "Fireworks", imageName: "fireworks", colors:fireworksColors, bgImages:fireworksImages))

        var galaxyColors:[UIColor] = []
        var galaxyImages:[UIImage] = []
        for m in 0...9 {
            galaxyColors.append(GridView.getColorOfImage(at:Int32(m), imagePrefix:"galaxy_"));
            galaxyImages.append(GridView.getImageAt(Int32(m), imagePrefix:"galaxy_"));
        }
        typeBg.append(TypeBG(name: "Galaxy", imageName: "galaxy", colors:galaxyColors, bgImages:galaxyImages))

        var heartColors:[UIColor] = []
        var heartImages:[UIImage] = []
        for m in 0...9 {
            heartColors.append(GridView.getColorOfImage(at:Int32(m), imagePrefix:"heart_"));
            heartImages.append(GridView.getImageAt(Int32(m), imagePrefix:"heart_"));

        }
        typeBg.append(TypeBG(name: "Heart", imageName: "heartCategory", colors:heartColors, bgImages:heartImages))
        
        var leafColors:[UIColor] = []
        var leafImages:[UIImage] = []
        for m in 0...9 {
            leafColors.append(GridView.getColorOfImage(at:Int32(m), imagePrefix:"leaf_"));
            leafImages.append(GridView.getImageAt(Int32(m), imagePrefix:"leaf_"));

        }
        typeBg.append(TypeBG(name: "Leaf", imageName: "leafCategory", colors:leafColors, bgImages:leafImages))

        
        var marbleColors:[UIColor] = []
        var marbleImages:[UIImage] = []
        for m in 0...9 {
            marbleColors.append(GridView.getColorOfImage(at:Int32(m), imagePrefix:"marble_"));
            marbleImages.append(GridView.getImageAt(Int32(m), imagePrefix:"marble_"));

        }
        typeBg.append(TypeBG(name: "Marble", imageName: "marble", colors:marbleColors, bgImages:marbleImages))
       
        var neonColors:[UIColor] = []
        var neonImages:[UIImage] = []
        for m in 0...9 {
            neonColors.append(GridView.getColorOfImage(at:Int32(m), imagePrefix:"neon_"));
            neonImages.append(GridView.getImageAt(Int32(m), imagePrefix:"neon_"));

        }
        typeBg.append(TypeBG(name: "Neon", imageName: "neon", colors:neonColors, bgImages:neonImages))
       
        var roseColors:[UIColor] = []
        var roseImages:[UIImage] = []
        for m in 0...9 {
            roseColors.append(GridView.getColorOfImage(at:Int32(m), imagePrefix:"rose_"));
            roseImages.append(GridView.getImageAt(Int32(m), imagePrefix:"rose_"));

        }
        typeBg.append(TypeBG(name: "Rose", imageName: "rose", colors:roseColors, bgImages:roseImages))
       
        var vintageColors:[UIColor] = []
        var vintageImages:[UIImage] = []
        for m in 0...9 {
            vintageColors.append(GridView.getColorOfImage(at:Int32(m), imagePrefix:"vintage_"));
            vintageImages.append(GridView.getImageAt(Int32(m), imagePrefix:"vintage_"));
        }
        typeBg.append(TypeBG(name: "Vintage", imageName: "vintage", colors:vintageColors, bgImages:vintageImages))
       
    }
    
    @objc func doneAction() {
        print("Done in bg is clicked")
        let myNotificationName = Notification.Name("BringUIBacktoNormal")
        NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: nil)
        if #available(iOS 16.0, *) {
            MoveUIDown()
            dismiss(animated: true, completion: nil)
        }
    }
    
   
//    override func viewWillLayoutSubviews() {
//        // Apply 3D effects
//        DispatchQueue.main.async {
//            self.applySubtle3DTransformTotopView()
//        }
//    }
//    
//    func applySubtle3DTransformTotopView() {
//        // Add subtle 3D shadow to the bottom view for a smooth, refined look
//        lineView.layer.shadowOpacity = 0.2  // Slightly lighter shadow
//        lineView.layer.shadowOffset = CGSize(width: 0, height: 4)  // More subtle shadow offset
//        lineView.layer.shadowRadius = 4  // Smaller shadow radius
//        // Lift the bottom view slightly for a floating effect
//        let transform = CATransform3DMakeTranslation(0, 5, 0)  // Slightly lift the view for a subtle floating effect
//        lineView.layer.transform = transform
//    }
    
    // MARK: - Setup Methods
    private func setupCollectionViews() {
        
        typeOfBGLayout = UICollectionViewFlowLayout()
        typeOfBGLayout.scrollDirection = .horizontal
        if isiPod()
        {
            typeOfBGLayout.minimumLineSpacing = 5
            typeOfBGLayout.minimumInteritemSpacing = 1
        }
        else
        {
            typeOfBGLayout.minimumLineSpacing = 20
            typeOfBGLayout.minimumInteritemSpacing = 5
        }
        
       
        typeOfBGCollectionView = UICollectionView(frame: .zero, collectionViewLayout: typeOfBGLayout)
        
        typeOfBGCollectionView.backgroundColor = .clear
       
        
        
        availableBGLayout = UICollectionViewFlowLayout()
        availableBGLayout.scrollDirection = .horizontal
        availableBGLayout.itemSize = CGSize(width: 60, height: 60)
        availableBGLayout.minimumLineSpacing = offset
        availableBGLayout.minimumInteritemSpacing = offset*2
        availableBGCollectionView = UICollectionView(frame: .zero, collectionViewLayout: availableBGLayout)
        availableBGCollectionView.backgroundColor = .clear
        
        availableBGCollectionView.showsVerticalScrollIndicator = false
        availableBGCollectionView.showsHorizontalScrollIndicator = false
        
        typeOfBGCollectionView.showsVerticalScrollIndicator = false
        typeOfBGCollectionView.showsVerticalScrollIndicator = false
        
        
        
        // Register cells
        availableBGCollectionView.register(BGCell.self, forCellWithReuseIdentifier: BGCell.identifier)
        typeOfBGCollectionView.register(TypeBGCell.self, forCellWithReuseIdentifier:TypeBGCell.identifier)
        
        // Set delegates and data sources
        availableBGCollectionView.delegate = self
        availableBGCollectionView.dataSource = self
        
        typeOfBGCollectionView.delegate = self
        typeOfBGCollectionView.dataSource = self
        
        doneButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        titlLabel.text = "Backgrounds"
       
        // Add subviews
        view.addSubview(topView)
        topView.addSubview(titlLabel)
        topView.addSubview(doneButton)
        topView.addSubview(lineView)
        view.addSubview(availableBGCollectionView)
        view.addSubview(line_View)
        view.addSubview(bgViewForTypeBG)
        view.addSubview(typeOfBGCollectionView)
        
        // Layout
        topView.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        titlLabel.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        typeOfBGCollectionView.translatesAutoresizingMaskIntoConstraints = false
        line_View.translatesAutoresizingMaskIntoConstraints = false
        bgViewForTypeBG.translatesAutoresizingMaskIntoConstraints = false
        availableBGCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            topView.heightAnchor.constraint(equalToConstant: heightOfTitleBar),
            
//            titlLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 0),
            titlLabel.widthAnchor.constraint(equalToConstant: 150),
           // titlLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20),
            titlLabel.heightAnchor.constraint(equalToConstant: heightOfTitleBar),
            titlLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            titlLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor,constant: 0),

            doneButton.topAnchor.constraint(equalTo: topView.topAnchor, constant: 0),
            doneButton.widthAnchor.constraint(equalToConstant: heightOfTitleBar),
            doneButton.heightAnchor.constraint(equalToConstant: heightOfTitleBar),
            doneButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -offset*2),
           // doneButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            
        
            lineView.topAnchor.constraint(equalTo: topView.bottomAnchor,constant: -1),
            lineView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            
            availableBGCollectionView.topAnchor.constraint(equalTo: topView.bottomAnchor,constant: offset/2),
            availableBGCollectionView.leadingAnchor.constraint(equalTo: topView.leadingAnchor,constant: offset),
            availableBGCollectionView.trailingAnchor.constraint(equalTo:topView.trailingAnchor,constant: -offset),
           // availableBGCollectionView.heightAnchor.constraint(equalToConstant: 0),
            
            line_View.topAnchor.constraint(equalTo: availableBGCollectionView.bottomAnchor,constant: 0),
            line_View.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            line_View.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            line_View.heightAnchor.constraint(equalToConstant: 1),
            
            bgViewForTypeBG.topAnchor.constraint(equalTo: line_View.bottomAnchor, constant: 0),
            bgViewForTypeBG.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 0),
            bgViewForTypeBG.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bgViewForTypeBG.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant:0),
            
            typeOfBGCollectionView.topAnchor.constraint(equalTo: line_View.bottomAnchor, constant: 0),
            typeOfBGCollectionView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: offset),
//            typeOfBGCollectionView.heightAnchor.constraint(equalToConstant: 90),
            typeOfBGCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            typeOfBGCollectionView.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant:-offset),
            
            
            //typeOfBGCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        // Create and add the height constraint programmatically
            heightConstraint = availableBGCollectionView.heightAnchor.constraint(equalToConstant: 0) //imp
            heightConstraint?.isActive = true
        line_View.isHidden = true
        bgViewForTypeBG.backgroundColor = .clear
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == typeOfBGCollectionView
        {
            return typeBg.count
        }else {
            print("selcyed category stickers count ",typeBg[selectedTypeIndex].colors.count)
            return typeBg[selectedTypeIndex].colors.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == typeOfBGCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TypeBGCell.identifier, for: indexPath) as! TypeBGCell
            if indexPath.item < typeBg.count {
                let item = typeBg[indexPath.item]
                cell.configure(imageName: item.imageName)
            }
            return cell
        }else
        {
            if(selectedTypeIndex == 0)
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TypeBGCell.identifier, for: indexPath) as! TypeBGCell
                        cell.delegate = self
                        return cell
            }
            else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BGCell.identifier, for: indexPath) as! BGCell
                if indexPath.item < typeBg[selectedTypeIndex].colors.count {
                    let item = typeBg[selectedTypeIndex].colors[indexPath.item]
                    cell.configure(color: item)
                }
                return cell
            }
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == typeOfBGCollectionView
        {
            if(selectedTypeIndex != indexPath.item)
            {
                selectedTypeIndex = indexPath.item
            }
            print("selected Type Index ",selectedTypeIndex,"type bg count ",typeBg.count-1);
            if(selectedTypeIndex == 1)
            {
                line_View.isHidden = true
                bgViewForTypeBG.backgroundColor = .clear
                showColorPicker()
            }
            else if(selectedTypeIndex == 0)
            {
                line_View.isHidden = true
                bgViewForTypeBG.backgroundColor = .clear
                if UserDefaults.standard.integer(forKey: "PhotoLibraryPermission") == 1 {
                    checkAccessLevel()
                }
                else{
                    checkAccessLevel()
                }
               
            }
            else if(selectedTypeIndex == 2)
            {
                MoveUIDown()
                line_View.isHidden = true
                bgViewForTypeBG.backgroundColor = .clear
                let myNotificationName = Notification.Name("ChangeSessionColor")
                let params: [String: Any] = ["color": UIColor.white, "bgImage":typeBg[selectedTypeIndex].bgImages[0] ]
                NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: params)
            }
            else
            {
                line_View.isHidden = false
                bgViewForTypeBG.backgroundColor = .darkGray.withAlphaComponent(0.25)
                if( self.heightConstraint?.constant != self.heightConstant)
                {
                    MoveUIUP()
                    UIView.animate(withDuration: 0.6) {
                        self.heightConstraint?.constant = self.heightConstant
                        self.view.layoutIfNeeded()
                        self.sheetPresentationController?.detents =  [self.small]
                        }
                }else
                {
                    //scaleView(availableBGCollectionView, scale: 1.0, duration: 0.3)
                    //availableBGCollectionView.reloadData()
                }
            }
            
        }
        else
        {
            if indexPath.item < typeBg[selectedTypeIndex].colors.count {
                let myNotificationName = Notification.Name("ChangeSessionColor")
                let params: [String: Any] = ["color": typeBg[selectedTypeIndex].colors[indexPath.item],"bgImage":typeBg[selectedTypeIndex].bgImages[indexPath.item]]
                NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: params)
            }
        }
        
    }
    
    func checkAccessLevel()
    {
        //check Access level
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .authorized:
                print("Full access granted")
                DispatchQueue.main.async {
                    self.presentImagePicker()
                }
                
            case .limited:
                print("Limited access granted")
                DispatchQueue.main.async {
                    self.presentImagePicker()
                }
                
            case .denied, .restricted:
                print("Access denied or restricted")
                DispatchQueue.main.async {
                    self.openSettings()
                }
            case .notDetermined:
                print("User has not yet made a choice")
                DispatchQueue.main.async {
                    self.openSettings()
                }
            @unknown default:
                break
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == availableBGCollectionView {
//            if(selectedTypeIndex != indexPath.item)
//            {
//                cell.alpha = 0
//                cell.transform = CGAffineTransform(translationX: 0, y: 50)
//                //delay: 0.1 * Double(indexPath.item)
//                UIView.animate(withDuration: 0.35, delay: 0.1 * Double(indexPath.item), options: .curveEaseInOut, animations: {
//                    cell.alpha = 1
//                    cell.transform = .identity
//                })
           // }
            
            cell.transform = CGAffineTransform(scaleX: 0, y: 0)
            cell.alpha = 0.0  // Make it transparent initially

              // Animate to scale 1 (full size)
              UIView.animate(withDuration: 0.6,  // Duration for smooth animation
                             delay: 0,
                             usingSpringWithDamping: 0.6,  // Bouncy effect
                             initialSpringVelocity: 0.8,
                             options: [.curveEaseInOut]) {
                  
                  cell.transform = CGAffineTransform(scaleX: 1, y: 1)
                  cell.alpha = 1.0  // Make it fully visible
              }
        }
    }
    
    func scaleWithCABasicAnimation(_ view: UIView, scale: CGFloat, duration: CFTimeInterval) {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = scale
        scaleAnimation.duration = duration
        //scaleAnimation.autoreverses = true
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        view.layer.add(scaleAnimation, forKey: "scale")
    }
    
    func scaleView(_ view: UIView, scale: CGFloat, duration: TimeInterval) {
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: {
                           view.transform = CGAffineTransform(scaleX: 1, y: scale)
                       }) { _ in
            UIView.animate(withDuration: duration) {
                view.transform = .identity
            }
        }
    }
  
    
    func openSettings() {
        // Get the description from Info.plist
        let accessDescription = Bundle.main.object(forInfoDictionaryKey: "NSPhotoLibraryUsageDescription") as? String ?? "Permission required"

        let alertController = UIAlertController(
            title: accessDescription,
            message: "To give permissions, tap on 'Change Settings' button.",
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        let settingsAction = UIAlertAction(title: "Change Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL)
            }
        }
        alertController.addAction(settingsAction)

        if let presented = self.presentedViewController {
            presented.dismiss(animated: true) {
                self.present(alertController, animated: true)
            }
        } else {
            self.present(alertController, animated: true)
        }
    }
    
    func isiPod() -> Bool {
        let device = UIDevice.current
        return device.userInterfaceIdiom == .phone && UIScreen.main.bounds.height == 568
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if #available(iOS 16.0, *) {
            if collectionView == typeOfBGCollectionView {
                let screenWidth = UIScreen.main.bounds.width
                //let screenHeight = UIScreen.main.bounds.height
                print("screen height ",screenHeight)
                if UIDevice.current.userInterfaceIdiom == .pad {
                    print("is ipad")
                    let width = (screenWidth - 50) / 7.5
                    return CGSize(width: width, height:width)
                }else if isiPod()
                {
                    print("is ipod")
                    let width = (screenWidth - 70) / 4
                    return CGSize(width: width, height:width)
                }
                else
                {
                    print("is iphone")
                    let width = (screenWidth - 70) / 5
                    return CGSize(width: width, height:width)
                }
            } else {
                
                if isiPod(){
                    return CGSize(width: 40, height: 40)
                }else
                {
                    return CGSize(width: cellsize, height: cellsize)
                }
            }
//        }
//        else {
//            if collectionView == typeOfBGCollectionView {
//                let screenWidth = UIScreen.main.bounds.width
//                //let screenHeight = UIScreen.main.bounds.height
//                print("screen height ",screenHeight)
//                if UIDevice.current.userInterfaceIdiom == .pad {
//                    print("is ipad")
//                    let width = (screenWidth - 50) / 7.5
//                    return CGSize(width: width, height:width)
//                }
//                else if isiPod()
//                {
//                    print("is ipod")
//                    let width = (screenWidth - 70) / 4
//                    return CGSize(width: width, height:width)
//                }
//                else
//                {
//                    print("is iphone")
//                    let width = (screenWidth - 70) / 5
//                    return CGSize(width: width, height:width)
//                }
//            }
//            else
//            {
//                if isiPod(){
//                    return CGSize(width: 40, height: 40)
//                }else
//                {
//                    return CGSize(width: cellsize, height: cellsize)
//                }
//                    
//            }
//        }
    }
    
    func MoveUIDown()
    {
//        let myNotificationName = Notification.Name("BringUIBacktoNormal")
//        NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: nil)
        if( self.heightConstraint?.constant != 0)
        {
            UIView.animate(withDuration: 0.5) {
                self.heightConstraint?.constant = 0
                self.view.layoutIfNeeded()
                self.sheetPresentationController?.detents =  [self.verySmall]
            }
        }
    }
    
    func MoveUIUP()
    {
        let myNotificationName = Notification.Name("BringUIUP")
        NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: nil)
    }
    
    func MoveUINormal()
    {
        let myNotificationName = Notification.Name("BringUIBacktoNormal")
        NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: nil)
    }
    
    func showColorPicker() {
//           let colorPicker = UIColorPickerViewController()
//           colorPicker.delegate = self
//           colorPicker.selectedColor = view.backgroundColor ?? .white // Default color
//           
//           if let sheet = colorPicker.sheetPresentationController {
//               // Define a custom medium size detent (e.g., 40% o {
//               if #available(iOS 16.0, *) {
//                   sheet.detents = [
//                       .custom(identifier: .medium) { context in
//                           return 650 // Height for the medium detent
//                       }
//                   ]
//               } else {
//                   // Fallback on earlier versions
//               }
//               sheet.selectedDetentIdentifier = .medium
//               sheet.prefersGrabberVisible = true // Show the grabber for resizing
//               sheet.preferredCornerRadius = 20 // Round the corners
//               sheet.largestUndimmedDetentIdentifier = .medium // Background remains visible
//           }
//           
//           present(colorPicker, animated: true, completion: nil)
        
        let colorPicker = UIColorPickerViewController()
        colorPicker.modalPresentationStyle = .formSheet
        colorPicker.delegate = self

        if let sheet = colorPicker.sheetPresentationController {
            if #available(iOS 16.0, *) {
                sheet.detents = [
                    .custom(identifier: .medium) { context in
                       // return 650
                        return self.screenHeight * 0.4;
                    }
                ]
            } else {
                sheet.detents = [.medium()]
            }
            
            sheet.selectedDetentIdentifier = .medium
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }

        present(colorPicker, animated: true)
       }
     
    func openColorPicker()
    {
        MoveUIDown()
         //MoveUINormal()
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.supportsAlpha = false // Set to true if you want alpha selection
        colorPicker.modalPresentationStyle = .pageSheet
        // Configure sheet presentation (iOS 15+)
        if let sheet = colorPicker.sheetPresentationController {
            sheet.detents = [.medium(),.large()]
            sheet.prefersEdgeAttachedInCompactHeight = true // Attaches to bottom edge in compact height
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true // Makes width adjust
           // sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true // Optional, shows grabber handle
        }
        present(colorPicker, animated: true, completion: nil)
    }
    
    func presentImagePicker()
    {
        UserDefaults.standard.set(1, forKey: "PhotoLibraryPermission")
        MoveUIDown()
        //MoveUINormal()
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1 // Allow only one image
        configuration.filter = .images // Only images, no videos
            
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    

    // MARK: - UIColorPickerViewControllerDelegate
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        //colorButton.backgroundColor = viewController.selectedColor
        // Define a constant for the notification name
        let myNotificationName = Notification.Name("ChangeSessionColor")
        let params: [String: Any] = ["color": viewController.selectedColor,"bgImage":imageFromColor(viewController.selectedColor)]
        NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: params)
        //viewController.dismiss(animated: true)
        if let sheet = viewController.sheetPresentationController {
            sheet.selectedDetentIdentifier = .medium
        }
    }

    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        print("Final selected color: \(viewController.selectedColor)")
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return true
    }

    
    // Delegate callback for PHPickerViewController
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let result = results.first else { return }

        let provider = result.itemProvider
        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { image, error in
                 DispatchQueue.main.async {
                     if let selectedImage = image as? UIImage {
                         // Handle the selected image
                         self.handleSelectedImage(selectedImage)
                     } else {
                         print("Failed to load image: \(error?.localizedDescription ?? "Unknown error")")
                         self.showAlert(on: self, title: "Error", message: "Failed to load image")

                     }
                 }
             }
         }
     }
     
    func showAlert(on viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add "OK" button
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert
        viewController.present(alert, animated: true, completion: nil)
    }
    
    
     func handleSelectedImage(_ image: UIImage) {
         // Handle the selected image, e.g., display it in an UIImageView
         print("Image Selected: \(image.size)")
//         let maxSize = CGSize(width: image.size.width, height: image.size.height) // Max size
//         let resizedImage = image.resizedAspectFit(to: maxSize)
         let color:UIColor  = GridView.getColorFor(image)
         // Define a constant for the notification name
         let myNotificationName = Notification.Name("ChangeSessionColor")
         let params: [String: Any] = ["color": color]
         NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: params)
     }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("Sheet was dismissed")
        let dismissedVC = presentationController.presentedViewController
            print("Dismissed ViewController: \(type(of: dismissedVC))")
    }
    
}
