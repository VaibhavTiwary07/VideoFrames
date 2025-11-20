//
//  AspectRatioViewController.swift
//  VnameeoFrames
//
//  Created by apple on 28/01/25.
//

import Foundation
import UIKit

class AspectRatioViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    let screenWidth : CGFloat  = UIScreen.main.bounds.width
    let screenHeight : CGFloat = UIScreen.main.bounds.height
    let small_DetentHeight : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? (UIScreen.main.bounds.height * 0.25) : (UIScreen.main.bounds.height * 0.25)
 //   let mediumSmall_DetentHeight : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? (UIScreen.main.bounds.height * 0.18) : (UIScreen.main.bounds.height * 0.20)
    // UNUSED: let verySmall_DetentHeight : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? (UIScreen.main.bounds.height * 0.15) : (UIScreen.main.bounds.height * 0.15)
    var heightOfTitleBar : CGFloat = 60
    let offset : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 10 : 5
    
    // MARK: - UI Elements
    var topView: ShadowContainerView = {
        let view = ShadowContainerView()
        let user_default_color =  UIColor(red:28/255.0, green:32/255.0 , blue:38/255.0, alpha:1.0)
        view.backgroundColor = user_default_color //UIColor(red: 48.0/255.0, green: 51.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        // Add shadow for 3D effect
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOpacity = 0.5
//        view.layer.shadowOffset = CGSize(width: 0, height: 4)
//        view.layer.shadowRadius = 12
//       // view.layer.cornerRadius = 8  // Subtle corner radius
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
    
    
    var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 48.0/255.0, green: 51.0/255.0, blue: 58.0/255.0, alpha: 1.0) //.darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
//        // Add shadow for 3D effect
//        view.layer.shadowColor = UIColor.white.cgColor
//        view.layer.shadowOpacity = 1
//        view.layer.shadowOffset = CGSize(width: 0, height: 2)
//        view.layer.shadowRadius = 8
//        view.layer.masksToBounds = false
        
        return view
    }()
    
    var categories: [Category] = [
        Category(name: "Sizes",title:"Sizes" ,stickers:[
            Sticker(name: "Custom", imageName: "custom"),
            Sticker(name: "1:1", imageName: "1_1"),
            Sticker(name: "2:3", imageName: "2_3"),
            Sticker(name: "Story", imageName: "story"),
            Sticker(name: "Portrait", imageName: "4_5"),
            Sticker(name: "Card", imageName: "5_4"),
            Sticker(name: "Wallpaper", imageName: "9_16"),
            Sticker(name: "4x6", imageName: "4_6"),
            Sticker(name: "5x7", imageName: "5_7"),
            Sticker(name: "8x10", imageName: "8_10"),
            Sticker(name: "9:16", imageName: "9_16"),
            Sticker(name: "3:4", imageName: "3_4"),
            Sticker(name: "4:3", imageName: "4_3"),
            Sticker(name: "3:2", imageName: "3_2"),
            Sticker(name: "16:9", imageName: "16_9")
        ])
    ]
    
    var selectedCategoryIndex: Int = 0 {
        didSet {
            stickersCollectionView.reloadData()
            print("new index selected")
        }
    }
    

    
    var doneButton: UIButton = {
        let btn = UIButton()
        btn.tintColor = .white
        btn.backgroundColor = .clear
        btn.setImage(UIImage(named: "done2")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.isUserInteractionEnabled = true
        btn.imageView?.contentMode = .scaleAspectFit
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var stickerLayout:UICollectionViewFlowLayout!
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
   
    
    private var stickersCollectionView: UICollectionView!
//    = {
//           let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//           layout.minimumLineSpacing = 10
//           layout.minimumInteritemSpacing = 10
//           let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//           collectionView.backgroundColor = .clear
//           return collectionView
//       }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if((UIDevice.current.userInterfaceIdiom == .pad) )
        {
            heightOfTitleBar = 60
        }
        else if(isiPod())
        {
            heightOfTitleBar = 40
        }
        else
        {
            heightOfTitleBar =  UIScreen.main.bounds.height*0.06
        }
        let user_default_color =  UIColor(red:28/255.0, green:32/255.0 , blue:38/255.0, alpha:1.0)
        view.backgroundColor = user_default_color
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
//        view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
//        view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

       // var gridStickers:[Sticker] = []
//        for index in 1..<100 {
//            let imgName: String
//            if index < 10 {
//                imgName = "thumbles_0"
//            } else {
//                imgName = "thumbles_"
//            }
//            // Or combine in one line:
//            let imgNameWithPng = "\(imgName)\(index).png"
//            gridStickers.append(Sticker(name: "", imageName: imgNameWithPng))
//        }
       // categories.append(Category(name: "Grid", title: "Grid", stickers: gridStickers))
       
        setupCollectionViews()
        
    }
    override func viewWillLayoutSubviews() {
        // Apply 3D effects
//        DispatchQueue.main.async {
//            self.applySubtle3DTransformTotopView()
//        }
     //   setupRoundedCorners() // Ensure correct shape on layout changes
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
//        guard stickersCollectionView.contentSize.width > stickersCollectionView.frame.width else { return }
//
//        if pulseCount >= 2 {
//            pulseCount = 0
//            return
//        }
//
//        pulseCount += 1
//
//        let scrollOffset: CGFloat = 100
//        let initialOffset = stickersCollectionView.contentOffset
//
//        // Use UIView.animate for easing + UIView.animateKeyframes for keyframe animation
//        UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseInOut) {
//            UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: [.calculationModePaced]) {
//                
//                // Scroll right
//                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.4) {
//                    self.stickersCollectionView.setContentOffset(CGPoint(x: initialOffset.x + scrollOffset, y: initialOffset.y), animated: false)
//                }
//                // Scroll back
//                UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.4) {
//                    self.stickersCollectionView.setContentOffset(initialOffset, animated: false)
//                }
//            }
//        } completion: { _ in
//            self.animateScrollPulse()  // Repeat animation 2 times
//        }
//    }
    
    // UNUSED:
    /*
    private func setupRoundedCorners() {
        let path = UIBezierPath(roundedRect: topView.bounds,
                                   byRoundingCorners: [.topLeft, .topRight],
                                   cornerRadii: CGSize(width: 8, height: 8)) // Adjust radius as needed

           let mask = CAShapeLayer()
           mask.path = path.cgPath
        topView.layer.mask = mask
        // Apply shadow using a separate shadowPath to match the view shape
        topView.layer.shadowPath = path.cgPath
       }
    */
    
//    func applySubtle3DTransformTotopView() {
//        // Add subtle 3D shadow to the bottom view for a smooth, refined look
//        lineView.layer.shadowOpacity = 0.4  // Slightly lighter shadow
//        lineView.layer.shadowOffset = CGSize(width: 0, height: 4)  // More subtle shadow offset
//        lineView.layer.shadowRadius = 9 // Smaller shadow radius
//      //  topView.layer.cornerRadius = 8  // Rounded corners for smoothness
//
//        // Lift the bottom view slightly for a floating effect
//        let transform = CATransform3DMakeTranslation(0, 5, 0)  // Slightly lift the view for a subtle floating effect
//        lineView.layer.transform = transform
//    }
    
    @objc func reloadStickerInHorizontalCollectionView()
    {
        stickerLayout.scrollDirection = .horizontal
        stickerLayout.minimumLineSpacing = 10
        stickerLayout.minimumInteritemSpacing = 10
        leadingConstraint.constant = 10
        trailingConstraint.constant = -10
        UIView.animate(withDuration: 0.3) {
            self.stickersCollectionView.collectionViewLayout.invalidateLayout()
        }
        print("horizontal direction")
    }
    
    @objc func reloadStickerInVerticalCollectionView()
    {
        print("vetrical called ");
        stickerLayout.scrollDirection = .vertical
        stickerLayout.minimumLineSpacing = 5
        stickerLayout.minimumInteritemSpacing = 5
        leadingConstraint.constant = 35 // Change the value as needed
        trailingConstraint.constant = -35
        UIView.animate(withDuration: 0.3) {
            self.stickersCollectionView.collectionViewLayout.invalidateLayout()
        }
        print("vertical direction, screen width ",screenWidth,screenWidth)
    }
    
    // UNUSED:
    /*
    // Update collection view data
    func updateCollectionView() {
        stickersCollectionView.reloadData()  // Reload collection view with new data
    }
    */
    
    
    
    // MARK: - Setup Methods
    private func setupCollectionViews() {
        
        stickerLayout = UICollectionViewFlowLayout()
        stickerLayout.scrollDirection = .horizontal
        stickerLayout.minimumLineSpacing = 10
        stickerLayout.minimumInteritemSpacing = 10
        
        stickersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: stickerLayout)
        stickersCollectionView.backgroundColor = .clear

        
        // Register cells
       // categoryCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
         stickersCollectionView.register(AspectRatioCell.self, forCellWithReuseIdentifier:AspectRatioCell.identifier)
        
        // Set delegates and data sources
//        categoryCollectionView.delegate = self
//        categoryCollectionView.dataSource = self
        
        stickersCollectionView.delegate = self
        stickersCollectionView.dataSource = self
        
        doneButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        
        stickersCollectionView.backgroundColor = .clear;
        
        
        titlLabel.text = "Ratios"
        
        // Add subviews
        view.addSubview(topView)
        topView.addSubview(titlLabel)
        //topView.addSubview(categoryCollectionView)
        topView.addSubview(doneButton)
        topView.addSubview(lineView)
        view.addSubview(stickersCollectionView)
        
        // Layout
        topView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        titlLabel.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
      //  categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        stickersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        leadingConstraint = stickersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        leadingConstraint.isActive = true
        trailingConstraint = stickersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        trailingConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            
            topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            topView.heightAnchor.constraint(equalToConstant: heightOfTitleBar),
            
           // titlLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 0),
            titlLabel.widthAnchor.constraint(equalToConstant: 150),
            //titlLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20),
            titlLabel.heightAnchor.constraint(equalToConstant: heightOfTitleBar),
            titlLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            titlLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor,constant: offset),

//            categoryCollectionView.topAnchor.constraint(equalTo: topView.topAnchor,constant: 10),
//            categoryCollectionView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
//            categoryCollectionView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
//            categoryCollectionView.heightAnchor.constraint(equalToConstant: 50),
            //categoryCollectionView.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: 0),
            
            doneButton.topAnchor.constraint(equalTo: topView.topAnchor,constant: 0),
            doneButton.widthAnchor.constraint(equalToConstant: heightOfTitleBar),
            doneButton.heightAnchor.constraint(equalToConstant: heightOfTitleBar),
            doneButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -offset*2),
           // doneButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            
            
            lineView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            
        
            stickersCollectionView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 6),
        //stickersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
        //stickersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stickersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -offset)
        ])
    }
    
    // MARK: - UICollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == categoryCollectionView {
//            return categories.count
//        }
//        else
      //  {
            print("selcyed category stickers count ",categories[selectedCategoryIndex].stickers.count)
            return categories[selectedCategoryIndex].stickers.count
      //  }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AspectRatioCell.identifier, for: indexPath) as! AspectRatioCell
        if indexPath.item < categories[selectedCategoryIndex].stickers.count {
            cell.configure(with: categories[selectedCategoryIndex].stickers[indexPath.item])
        }
        return cell
    }
    
    // MARK: - UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView == categoryCollectionView {
//            selectedCategoryIndex = indexPath.item
//        }
//        else
//        {
            if(categories[selectedCategoryIndex].name == "Sizes")
            {
                var aspectName : String = ""
                if indexPath.item < categories[selectedCategoryIndex].stickers.count {
                    aspectName = categories[selectedCategoryIndex].stickers[indexPath.item].name
                }
                print("aspect ratio Selected item: \(aspectName)")
                var aspectNum = 0;
                if(aspectName == "Custom")
                {
                    showAspectRatioPopup()
                }
                else if(aspectName == "1:1")
                {
                    aspectNum = Int(ASPECTRATIO_1_1.rawValue)
                }
                else if(aspectName == "Wallpaper")
                {
                    aspectNum = Int(ASPECTRATIO_WALLPAPER.rawValue)
                }
                else if(aspectName == "9:16" || aspectName == "Story")
                {
                    aspectNum = Int(ASPECTRATIO_9_16.rawValue)
                }
                else if(aspectName == "Portrait")
                {
                    aspectNum = Int(ASPECTRATIO_4_5.rawValue)
                }
                else if(aspectName == "Card")
                {
                    aspectNum = Int(ASPECTRATIO_5_4.rawValue)
                }
                else if(aspectName == "4x6")
                {
                    aspectNum = Int(ASPECTRATIO_4_6.rawValue)
                }
                else if(aspectName == "5x7")
                {
                    aspectNum = Int(ASPECTRATIO_5_7.rawValue)
                }
                else if(aspectName == "8x10")
                {
                    aspectNum = Int(ASPECTRATIO_8_10.rawValue)
                }
                else if(aspectName == "16:9")
                {
                    aspectNum = Int(ASPECTRATIO_16_9.rawValue)
                }
                else if(aspectName == "4:3")
                {
                    aspectNum = Int(ASPECTRATIO_4_3.rawValue)
                }
                else  if(aspectName == "2:3")
                {
                    aspectNum = Int(ASPECTRATIO_2_3.rawValue)
                }
                else if(aspectName == "3:2")
                {
                    aspectNum = Int(ASPECTRATIO_3_2.rawValue)
                }
                else if(aspectName == "3:4")
                {
                    aspectNum = Int(ASPECTRATIO_3_4.rawValue)
                }
                if(aspectName != "Custom")
                {
                    // Define a constant for the notification name
                    let myNotificationName = Notification.Name("aspectratiochanged")
                    let params: [String: Any] = ["aspectratio": NSNumber(value: aspectNum)]
                    NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: params)
                }
            }else
            {
                // Define a constant for the notification name
                let myNotificationName = Notification.Name("SelectedFrame")
                let params: [String: Any] = ["FrameIndex": NSNumber(value: indexPath.item+1)]
                NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: params)
            }
            // Animate to medium detent after presentation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
         if let sheet = self.sheetPresentationController
        {
             sheet.animateChanges {
               if #available(iOS 16.0, *) {
            let smallDetent = UISheetPresentationController.Detent.custom(identifier: .init("small")) { context in
                  return self.small_DetentHeight }
                sheet.selectedDetentIdentifier = smallDetent.identifier
            }
            else
            {
               sheet.selectedDetentIdentifier = .medium
            }
           self.reloadStickerInHorizontalCollectionView()
        }
      }
    }
    //    }
 }
    
    // MARK: - Show Aspect Ratio Popup
    @objc func showAspectRatioPopup() {
        let alert = UIAlertController(title: "Enter Aspect Ratio", message: nil, preferredStyle: .alert)

        // Add Width Field
        alert.addTextField { textField in
            textField.placeholder = "Width"
            textField.keyboardType = .numberPad
        }

        // Add Height Field
        alert.addTextField { textField in
            textField.placeholder = "Height"
            textField.keyboardType = .numberPad
        }

        // Cancel Button
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)

        // OK Button
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak alert] _ in
            guard let textFields = alert?.textFields,
                  let widthText = textFields[0].text, !widthText.isEmpty,
                  let heightText = textFields[1].text, !heightText.isEmpty else {
                print("Invalid input")
                return
            }

            self.handleAspectRatio(width: widthText, height: heightText)
        }

        alert.addAction(cancelAction)
        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }

    // MARK: - Handle Aspect Ratio
    func handleAspectRatio(width: String, height: String) {
        print("Width: \(width), Height: \(height)")
        let _width = Float(width)
        let _height = Float(height)
        var msg :String = ""
        var apply : Bool = false
        if(_width == 0 || _height == 0)
        {
            apply = false
            msg = "Width: \(width)\nHeight: \(height) can not be applied"
        }
        else
        {
            apply = true
            msg =  "Width: \(width)\nHeight: \(height)"
        }
        let resultAlert = UIAlertController(
            title: "Aspect Ratio",
            message: msg,
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
            if(apply){
                let aspectRatioNotification = Notification.Name("customspectRatioSelected")
                NotificationCenter.default.post(name: aspectRatioNotification, object: nil, userInfo: [
                    "width": width,
                    "height": height
                ])
            }
        }
        resultAlert.addAction(okAction)

        present(resultAlert, animated: true, completion: nil)
    }
    
    func isiPod() -> Bool {
        let device = UIDevice.current
        return device.userInterfaceIdiom == .phone && UIScreen.main.bounds.height == 568
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == categoryCollectionView {
//            return CGSize(width: 100, height: 50)
//        } else {
           // let width = (collectionView.frame.width - 30) / 3
        if(stickerLayout.scrollDirection == .vertical)
        {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return CGSize(width: screenWidth/4, height: screenHeight/4.5)
            }
            else if(isiPod())
            {
                return CGSize(width: screenWidth/3, height: screenHeight/3)
            }
            else
            {
                return CGSize(width: screenWidth/4, height: screenHeight/4)
            }
        }
        else
        {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return CGSize(width: 100, height: screenHeight/6.5)
            }
            else if(isiPod())
            {
                return CGSize(width: 110, height: 200)
            }
            else
            {
                return CGSize(width: 100, height: screenHeight/5.8)
            }
        }
     //   }
    }
    
    @objc func doneAction() {
        print("Done in bg is clicked")
        MoveUIDown()
        dismiss(animated: true, completion: nil)
    }
    
    func MoveUIDown()
    {
        let myNotificationName = Notification.Name("BringUIBacktoNormal")
        NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: nil)
    }
    
    // UNUSED:
    /*
    func MoveUIUP()
    {
        let myNotificationName = Notification.Name("BringUIUP")
        NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: nil)
    }
    */
    
}
