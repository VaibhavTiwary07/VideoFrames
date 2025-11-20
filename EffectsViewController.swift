//
//  EffectsViewController.swift
//  VideoFrames
//
//  Created by apple on 20/03/25.
//

import Foundation
import UIKit
class EffectsViewController :UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    var selectedFilterNum : Int  = -1
    let filtersCount = 13// adding original also
    var filters: [(image: UIImage?, isLocked: Bool)] = []
    let effectsInstance = Effects()
    
    var verySmall :UISheetPresentationController.Detent = .medium()
    var small :UISheetPresentationController.Detent = .medium()
    let screenWidth : CGFloat  = UIScreen.main.bounds.width
    let screenHeight : CGFloat = UIScreen.main.bounds.height
    let small_DetentHeight : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? (UIScreen.main.bounds.height * 0.25) : (UIScreen.main.bounds.height * 0.25)
    let verySmall_DetentHeight : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? (UIScreen.main.bounds.height * 0.15) : (UIScreen.main.bounds.height * 0.18)
    var heightOfTitleBar : CGFloat = 60
    // UNUSED: let heightConstant : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 80 : UIScreen.main.bounds.height*0.075
    let offset : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 10 : 5
    // UNUSED: let cellsize : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 60 : UIScreen.main.bounds.height*0.06
    // UNUSED: var initialBounds: CGRect?
   
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
        view.backgroundColor = color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    
    var effectLayout:UICollectionViewFlowLayout!
    
    var effectsCollectionView: UICollectionView!
    
    // UNUSED:
    /*
    var selectedTypeIndex: Int = 0 {
        didSet {
            print("new index selected")
        }
    }
    */
    
    @objc func handleNotification(_ notification: Notification) {
        print("Notification received: \(notification)")
        if(notification.name.rawValue == "FilterDoneInvoked")
        {
            dismiss(animated: false, completion: nil)
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
        NotificationCenter.default.addObserver(self,
           selector: #selector(handleNotification(_:)), name: NSNotification.Name("FilterDoneInvoked"),object: nil)
        
        let user_default_color =  UIColor(red:28/255.0, green:32/255.0 , blue:38/255.0, alpha:1.0)
        view.backgroundColor = user_default_color
        if #available(iOS 16.0, *) {
            self.verySmall = UISheetPresentationController.Detent.custom { context in
                return self.verySmall_DetentHeight
            }
            self.small = UISheetPresentationController.Detent.custom { context in
                return self.small_DetentHeight
            }
        } else {
            // Fallback on earlier versions
            self.verySmall = UISheetPresentationController.Detent.medium()
            self.small = UISheetPresentationController.Detent.medium()
        }
        for j in 0...filtersCount {
            loadData(j: Int32(j))
        }
        setupCollectionViews()
    }
    
    // UNUSED:
    /*
    func didTapButton(in cell: FilterCell) {
        if let indexPath = effectsCollectionView.indexPath(for: cell) {
            print("Button tapped in cell at index: \(indexPath.row)")
        }
    }
    */
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        pulseCount = 0  // Reset counter when the view appears
//            animateScrollPulse()
//    }
//
//    private var pulseCount = 0
//
//    private func animateScrollPulse() {
//        guard effectsCollectionView.contentSize.width > effectsCollectionView.frame.width else { return }
//
//        if pulseCount >= 2 {
//            pulseCount = 0
//            return
//        }
//
//        pulseCount += 1
//
//        let scrollOffset: CGFloat = 100
//        let initialOffset = effectsCollectionView.contentOffset
//
//        // Use UIView.animate for easing + UIView.animateKeyframes for keyframe animation
//        UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseInOut) {
//            UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: [.calculationModePaced]) {
//                
//                // Scroll right
//                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.4) {
//                    self.effectsCollectionView.setContentOffset(CGPoint(x: initialOffset.x + scrollOffset, y: initialOffset.y), animated: false)
//                }
//
//                // Scroll back
//                UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.4) {
//                    self.effectsCollectionView.setContentOffset(initialOffset, animated: false)
//                }
//            }
//        } completion: { _ in
//            self.animateScrollPulse()  // Repeat animation 2 times
//        }
//    }



    
    
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
    
    @objc func doneAction() {
        print("Done in filter is clicked")
        let params: [String: Any] = ["SelectedFilter":selectedFilterNum]
        let myNotificationName = Notification.Name("DoneApplyingfilter")
        NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: params)
        MoveUIDown()
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func enableDoneButton(enable:Bool)
    {
        doneButton.isEnabled = enable;
    }
    
    
    // MARK: - Setup Methods
    private func setupCollectionViews() {
        
        effectLayout = UICollectionViewFlowLayout()
        effectLayout.scrollDirection = .horizontal
        if isiPod()
        {
            effectLayout.minimumLineSpacing = 5
            effectLayout.minimumInteritemSpacing = 1
        }
        else
        {
            effectLayout.minimumLineSpacing = 20
            effectLayout.minimumInteritemSpacing = 5
        }
        
        
        effectsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: effectLayout)
        
        effectsCollectionView.backgroundColor = .clear
       
        effectsCollectionView.register(FilterCell.self, forCellWithReuseIdentifier:FilterCell.identifier)
        
       
        effectsCollectionView.delegate = self
        effectsCollectionView.dataSource = self
        
        doneButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        titlLabel.text = "Effects"
        
        // Add subviews
        view.addSubview(topView)
        topView.addSubview(titlLabel)
        topView.addSubview(doneButton)
        topView.addSubview(lineView)
        view.addSubview(effectsCollectionView)
        
        // Layout
        topView.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        titlLabel.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        effectsCollectionView.translatesAutoresizingMaskIntoConstraints = false
    
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
            
            
            effectsCollectionView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 0),
            effectsCollectionView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: offset),
            effectsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            effectsCollectionView.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant:-offset),
        ])
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filtersCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.identifier, for: indexPath) as! FilterCell
        if indexPath.item < filters.count {
            let filter = filters[indexPath.item]
            cell.configure(with: filter.image!, isLocked: filter.isLocked)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedFilterNum = indexPath.item
        print("selected Filter Num ",selectedFilterNum)
        let myNotificationName = Notification.Name("filterchanged")
        let params: [String: Any] = ["filterselected": NSNumber(value: indexPath.item)]
        NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: params)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    // UNUSED:
    /*
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
    */
    
    
    
    func isiPod() -> Bool {
        let device = UIDevice.current
        return device.userInterfaceIdiom == .phone && UIScreen.main.bounds.height == 568
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            print("screen height ",screenHeight)
            if UIDevice.current.userInterfaceIdiom == .pad {
                print("is ipad")
                let width = (screenWidth - 50) / 7.5
                return CGSize(width: width, height:width)
            }else if isiPod()
            {
                print("is ipod")
                let width = (screenWidth - 70) / 3.8
                return CGSize(width: width, height:width)
            }
            else
            {
                print("is iphone")
                let width = (screenWidth - 70) / 5
                return CGSize(width: width, height:width)
            }
    }
    
    // UNUSED:
    /*
    func MoveUIUP()
    {
        let myNotificationName = Notification.Name("BringUIUP")
        NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: nil)
    }
    */

    func MoveUIDown()
    {
        let myNotificationName = Notification.Name("BringUIBacktoNormal")
        NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: nil)
    }

    // UNUSED:
    /*
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return true
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("Sheet was dismissed")
        let dismissedVC = presentationController.presentedViewController
        print("Dismissed ViewController: \(type(of: dismissedVC))")
    }
    */
}
