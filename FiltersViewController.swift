//
//  FiltersViewController.swift
//  VideoFrames
//
//  Created by apple on 13/03/25.
//

import Foundation
import UIKit

class FiltersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var selectedFilterNum : Int  = -1
    var filtersCollectionView: UICollectionView!
//    var filtersLayout:UICollectionViewFlowLayout!
    let effectsInstance = Effects()
    let filtersCount = 19 // adding original also
    let heightOfTitleBar : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 60 : UIScreen.main.bounds.height*0.05
    var filters: [(image: UIImage?, isLocked: Bool)] = []
    let screenWidth : CGFloat  = UIScreen.main.bounds.width
    let screenHeight : CGFloat = UIScreen.main.bounds.height
    let offset : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 10 : 5
    let cellsize : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 75 : UIScreen.main.bounds.height*0.07
    let heightofCollectionView : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 100 : UIScreen.main.bounds.width*0.22
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
        label.font = UIFont(name: "Gilroy-Medium", size: (UIDevice.current.userInterfaceIdiom == .pad) ? 20 : UIScreen.main.bounds.height*0.02)//UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    var doneButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Done", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.layer.cornerRadius = 5.0
        btn.clipsToBounds = true
        btn.isUserInteractionEnabled = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private func applyGradientToDoneButton() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = doneButton.bounds
        let greenColor = UIColor(red: 188/255.0, green: 234/255.0, blue: 109/255.0, alpha: 1.0)
        let cyanColor = UIColor(red: 20/255.0, green: 249/255.0, blue: 245/255.0, alpha: 1.0)
        gradientLayer.colors = [greenColor.cgColor, cyanColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = 5.0
        doneButton.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    var lineView: UIView = {
        let view = UIView()
        let color = UIColor(red: 48.0/255.0, green: 51.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        view.backgroundColor = color 
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotification(_:)),
                                               name: NSNotification.Name("FilterDoneInvoked"),
                                               object: nil)

        let user_default_color =  UIColor(red:28/255.0, green:32/255.0 , blue:38/255.0, alpha:1.0)
        view.backgroundColor = user_default_color
        
        for j in 0...filtersCount {
            loadData(j: Int32(j))
        }
        setupCollectionView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if doneButton.layer.sublayers?.first(where: { $0 is CAGradientLayer }) == nil {
            applyGradientToDoneButton()
        }
    }

    @objc func handleNotification(_ notification: Notification) {
        print("Notification received: \(notification)")
        if(notification.name.rawValue == "FilterDoneInvoked")
        {
            dismiss(animated: false, completion: nil)
        }
    }
    
    func loadData(j:Int32)
    {
        if(j == 0)
        {
            let image  = UIImage(named: "pic_eff_image.png")
            filters.append((image,false))
        }
        else
        {
            let image = effectsInstance.getImageForItem(j-1)
            let locked = effectsInstance.getItemLockStatus(j-1)
            filters.append((image,locked))
        }
    }
    
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: cellsize, height: cellsize)
        layout.minimumLineSpacing = 10
        
        filtersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        filtersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        filtersCollectionView.backgroundColor = .clear
        filtersCollectionView.delegate = self
        filtersCollectionView.dataSource = self
        filtersCollectionView.register(FilterCell.self, forCellWithReuseIdentifier: "FilterCell")
        
        doneButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        titlLabel.text = "Effects"
        
        // Add subviews
        view.addSubview(topView)
        topView.addSubview(titlLabel)
        topView.addSubview(doneButton)
        topView.addSubview(lineView)
        
        // Layout
        topView.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        titlLabel.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(filtersCollectionView)
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            topView.heightAnchor.constraint(equalToConstant: heightOfTitleBar),
            
           // titlLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 0),
            titlLabel.widthAnchor.constraint(equalToConstant: 150),
            // titlLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20),
            titlLabel.heightAnchor.constraint(equalToConstant: heightOfTitleBar),
            titlLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            titlLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor,constant: offset),
            
            doneButton.widthAnchor.constraint(equalToConstant: 70),
            doneButton.heightAnchor.constraint(equalToConstant: 35),
            doneButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -offset*2),
            doneButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            
            
            lineView.topAnchor.constraint(equalTo: topView.bottomAnchor,constant: -1),
            lineView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            
            filtersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset),
            filtersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset),
            filtersCollectionView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: offset),
         //   filtersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -offset)
            filtersCollectionView.heightAnchor.constraint(equalToConstant: heightofCollectionView)
        ])
    }
    
    @objc func doneAction() {
        print("Done in filter is clicked")
        MoveUIDown()
        let params: [String: Any] = ["SelectedFilter":selectedFilterNum]
        let myNotificationName = Notification.Name("applyfilter")
        NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: params)
        dismiss(animated: true, completion: nil)
    }
    
    func MoveUIDown()
    {
        let myNotificationName = Notification.Name("BringUIBacktoNormal")
        NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filtersCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCell
        let filter = filters[indexPath.item]
        cell.configure(with: filter.image!, isLocked: filter.isLocked)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filtersCollectionView
        {
            selectedFilterNum = indexPath.item
            print("selected Filter Num ",selectedFilterNum)
                let myNotificationName = Notification.Name("filterchanged")
                let params: [String: Any] = ["filterselected":indexPath.item]
                NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: params)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == filtersCollectionView {
            
        }
    }
    
//    func isiPod() -> Bool {
//        let device = UIDevice.current
//        return device.userInterfaceIdiom == .phone && UIScreen.main.bounds.height == 568
//    }
//    
//    // MARK: - UICollectionViewDelegateFlowLayout
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//            let screenWidth = UIScreen.main.bounds.width
//            //let screenHeight = UIScreen.main.bounds.height
//            print("screen height ",screenHeight)
//            if UIDevice.current.userInterfaceIdiom == .pad {
//                print("is ipad")
//                let width = (screenWidth - 70) / 6.5
//                return CGSize(width: width, height:width)
//            }else if isiPod()
//            {
//                print("is ipod")
//                let width = (screenWidth - 70) / 5
//                return CGSize(width: width, height:width)
//            }
//            else
//            {
//                print("is iphone")
//                let width = (screenWidth - 70) / 5
//                return CGSize(width: width, height:width)
//            }
//    }
    
    
}
