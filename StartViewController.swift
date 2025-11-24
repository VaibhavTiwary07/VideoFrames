//
//  StartViewController.swift
//  VideoFrames
//
//  Created by Admin on 13/09/24.
//

import UIKit
import StoreKit
import AppTrackingTransparency
import AdSupport
import UserMessagingPlatform

@objc class StartViewController: UIViewController, UINavigationControllerDelegate {
    
    private lazy var loadVieww: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(9.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var menuButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(menuButtonTappedNew), for: .touchUpInside)
        btn.setImage(UIImage(named: "menu"), for: .normal)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var isMenuVisible = false

    private lazy var loadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ipad-pro-loading-page")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
   // private var adsTrackingCountNumber: Int?
   // private var remoteConfig: RemoteConfig!
   // private var remoteConfig: RemoteConfig!
    private var interstitial: InterstitialAd?
    private var uniqueIdentifier: String?
    var interestial_LaunchCount: Int = 0 // Int property for launch count
    var interestial_ShareCount: Int = 0 // Int property for share count
    var interestial_HomeButtonClickCount: Int = 0 // Int property for home button click count
    var savingCountNumber: Int = 0 // Int property for saving count
    var adsTrackingCountNumber: Int?// Int property for ads tracking count
    
    var remoteConfig: RemoteConfig! // Strong reference to Firebase RemoteConfig
    var rateUsRemoteCount: Int = 0 // Int property for rate us count
    var subscriptionMode: Int = 0 // Int property for subscription mode
    var native_homeCount: Int = 0
    // UNUSED: var interestial_HomeString: String?
    var interestial_ShareString: String?
    var interestial_HomeButtonClickString: String?
    var interestial_Launch: String?
    var savingCountString: String?
    var rateUspanelString: String?
    var subscriptionModeString: String?
    var nativeAd_HomeString: String?
    var adShowingValue: Int!
    var interstitialLaunchCount: Int?
    
    var loadingIndicator:  UIActivityIndicatorView = {
      let loadingIndicator = UIActivityIndicatorView(style: .large)
      // loadingIndicator.tintColor = .orange
      loadingIndicator.color = .white
      loadingIndicator.startAnimating()
      loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
      return loadingIndicator
    }()
    
     var loadingLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.text = "Restoring Purchase"
        // Set the font (customize font name and size as needed)
        //let dynamicFontSize = self.view.frame.height * 0.025 // Adjust this multiplier as needed
        // Set the font with specified weight (e.g., .bold)
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular) // Example: using HelveticaNeue-Bold with size 17
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    
 var loadingCloseButton: UIButton = {
        let btn = UIButton()
        // btn.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        btn.setImage(UIImage(named: "close_watermark"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(hideLoading), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var BgImageView: UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFill
        imgV.translatesAutoresizingMaskIntoConstraints = false
        imgV.image = UIImage(named: "bg_1stscreen")
        return imgV
    }()
  
    private lazy var menuTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.isUserInteractionEnabled = true
        
        // Create a stronger frosted glass effect using a blur effect
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.layer.cornerRadius = 10 // Adjust corner radius for a rounder look
        visualEffectView.clipsToBounds = true
        // Slightly increase the tint to enhance the frosted effect
        visualEffectView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        
        // Set the background view of the table
        tableView.backgroundView = visualEffectView
        // Register custom header and cells (ensure you have this set up for images/icons)
        tableView.register(MenuTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "CustomHeaderView")
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "menuCell")
        
        // Apply shadow to table cells for depth
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOpacity = 0.1
        tableView.layer.shadowOffset = CGSize(width: 0, height: 3)
        tableView.layer.shadowRadius = 5
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var activityIndicator: DotIndicatorView = {
        let indicator = DotIndicatorView()
       // indicator.backgroundColor = .green
        indicator.translatesAutoresizingMaskIntoConstraints = false
        //indicator.color = .black
        return indicator
    }()
    
    var logoImageView: UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "VideoCollagelogo")
        imgV.contentMode = .scaleAspectFit
        imgV.translatesAutoresizingMaskIntoConstraints = false
        return imgV
    }()
    
    var startButton: UIButton = {
        let btn = UIButton()
        btn.tintColor = .white
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(startAction), for: .touchUpInside)
        btn.isUserInteractionEnabled = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var viewController2: MainController?
    
    var startLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.text = "Start"
        lbl.font = UIFont(name: "Gilroy-Medium", size: 26) // Adjust the size as per your needs
        lbl.textColor = UIColor(red: 25.0/255.0, green: 184.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SRSubscriptionModel.shareKit().loadProducts()
//        SRSubscriptionModel.shareKit().checkingExpiryHere()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("--- StartViewController loaded ---")

        // Navigation bar styling - matching FrameSelectionController
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .black
            appearance.shadowColor = nil
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.white,
                .font: UIFont.boldSystemFont(ofSize: 17)
            ]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
        } else {
            navigationController?.navigationBar.barStyle = .black
            navigationController?.navigationBar.barTintColor = .black
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.titleTextAttributes = [
                .foregroundColor: UIColor.white,
                .font: UIFont.boldSystemFont(ofSize: 17)
            ]
        }
        navigationController?.navigationBar.tintColor = .white

        //InAppPurchaseManager.instance()?.loadStore()
        setUpConstraints()
        loadInterstitialAd()
        remoteConfigurationSetUp()
        
        self.loadVieww.isHidden = true
        self.loadingLabel.isHidden = true
        self.loadingIndicator.isHidden = true
        uniqueIdentifier = UIDevice.current.identifierForVendor?.uuidString
        
        
        self.adShowingValue = UserDefaults.standard.integer(forKey: "AdCanShow")
        
        
        gettingGdprTrackingCount()
        
        loadInterstitialAd()
        loadingShow()
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideMenuForBtn))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self // Set the delegate to control gesture behavior
        view.addGestureRecognizer(tapGesture)

        
        
        menuTableView.isHidden = true
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        // Set up the menu button with an image, target, and action
        if let menuImage = UIImage(named: "menu") {
            // Get the screen width to adjust the image size dynamically
            let screenWidth = UIScreen.main.bounds.width
            
            // Define a base size (adjust it to your needs) and calculate the dynamic size
//            let baseSize: CGFloat = 30 // Default size for smaller screens (e.g., iPhone SE)
            var dynamicSize = screenWidth * 0.1
            if UIDevice.current.userInterfaceIdiom == .phone {
                dynamicSize = screenWidth * 0.1 // 10% of screen width
            } else if UIDevice.current.userInterfaceIdiom == .pad {
                dynamicSize = screenWidth * 0.05 // 5% of screen width
            }

            // Resize the image to the calculated size
            let resizedMenuImage = resizeImageNew(image: menuImage, targetSize: CGSize(width: dynamicSize, height: dynamicSize))
            let customButton = UIButton(type: .system)
            customButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)

            // Adjust the button's frame (move it down by 10 points)
            customButton.frame = CGRect(x: 0, y: 10, width: resizedMenuImage!.size.width, height: resizedMenuImage!.size.height);
            customButton.setImage(resizedMenuImage, for: .normal)
//
            // Embed the button in a UIView
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: resizedMenuImage!.size.width, height: resizedMenuImage!.size.width))
            containerView.addSubview(customButton)
            
            // Create the UIBarButtonItem with the resized image
           // let menuButton = UIBarButtonItem(image: resizedMenuImage, style: .plain, target: self, action: #selector(menuButtonTapped))
            
            let barButtonItem = UIBarButtonItem(customView: containerView)
            barButtonItem.tintColor = .white // Set the tint color if needed
            navigationItem.leftBarButtonItem = barButtonItem
            newConsentDialogue()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(valueForAdShowing), name: UIApplication.willTerminateNotification, object: nil)

    
      //  self.title = "A"
        if let navigationBar = self.navigationController?.navigationBar {
            let titleFont = UIFont.systemFont(ofSize: 24, weight: .bold) // Adjust the size and weight as needed
            navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white, // Set the color to white
                NSAttributedString.Key.font: titleFont
            ]
            navigationBar.tintColor = UIColor.white
        }
                
        
        NotificationCenter.default.addObserver(self, selector: #selector(valueForAdShowing), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    @objc func valueForAdShowing() {
        print("Application Terminated---")
        
        // Set the value for "AdCanShow" in UserDefaults
        UserDefaults.standard.set(1, forKey: "AdCanShow")
        
        // Retrieve the value for "AdCanShow" from UserDefaults
        let retrievedValue = UserDefaults.standard.integer(forKey: "AdCanShow")
        
        // Assign the retrieved value to adShowingValue
        adShowingValue = retrievedValue != 0 ? retrievedValue : 1
        
        print("Value for AdCanShow set to \(String(describing: adShowingValue))")
    }
    
    // Function to resize the image
    func resizeImageNew(image: UIImage, targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    func setUpConstraints() {
        view.addSubview(BgImageView)
        view.addSubview(logoImageView)
        view.addSubview(startButton)
        view.addSubview(menuButton)
 
       // view.addSubview(menuButton)
        
        let screenWidth = UIScreen.main.bounds.width
        
        // Define a base size (adjust it to your needs) and calculate the dynamic size
//            let baseSize: CGFloat = 30 // Default size for smaller screens (e.g., iPhone SE)
        var dynamicSize = screenWidth * 0.1
        if UIDevice.current.userInterfaceIdiom == .phone {
            dynamicSize = screenWidth * 0.1 // 10% of screen width
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            dynamicSize = screenWidth * 0.11 // 5% of screen width
        }

        if UIDevice.current.userInterfaceIdiom == .phone {
            menuButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
            menuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenWidth * 0.025).isActive = true
        }
        else{
            menuButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5).isActive = true
            menuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenWidth * 0.005).isActive = true
        }
        menuButton.widthAnchor.constraint(equalToConstant: dynamicSize).isActive = true
        menuButton.heightAnchor.constraint(equalToConstant: dynamicSize).isActive = true
        
        BgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        BgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        BgImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        BgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let logoWidth = view.frame.width * 0.5 // 50% of the view's width
        let logoHeight = view.frame.height * 0.2 // 20% of the view's height
           
        logoImageView.widthAnchor.constraint(equalToConstant: logoWidth).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: logoHeight).isActive = true
        
        
        
        view.addSubview(startLabel)
        view.addSubview(menuTableView)
        view.addSubview(loadVieww)
        loadVieww.addSubview(loadingIndicator)
        loadVieww.addSubview(loadingLabel)
        loadVieww.addSubview(loadingCloseButton)
        loadVieww.bringSubviewToFront(loadingIndicator)
        
     
       }
    
    override func viewWillLayoutSubviews() {
        let buttonWidthMultiplier: CGFloat = 0.7 // 70% of the screen width
          let buttonHeightMultiplier: CGFloat = 0.08 // 8% of the screen height

          // Check if the device is an iPad
          if UIDevice.current.userInterfaceIdiom == .pad {
              // iPad-specific constraints for the start button
              startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
              startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height * 0.05).isActive = true // Lower the button
              startButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: buttonWidthMultiplier * 0.8).isActive = true // Reduce width for iPads
              startButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: buttonHeightMultiplier * 1.2).isActive = true // Slightly taller button for iPads
            //  startButton.layer.cornerRadius = 50
              startLabel.font = UIFont(name: "Gilroy-Medium", size: 39)
          } else {
              // Default constraints for iPhones
              
              startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
              startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height * 0.1).isActive = true
              startButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: buttonWidthMultiplier).isActive = true
              startButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: buttonHeightMultiplier).isActive = true
          }
        print("start button height is  ",startButton.frame.height)
        startButton.layer.cornerRadius = startButton.frame.height/2
        startLabel.centerXAnchor.constraint(equalTo: startButton.centerXAnchor).isActive = true
        startLabel.centerYAnchor.constraint(equalTo: startButton.centerYAnchor).isActive = true
        
        menuTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        menuTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        menuTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        menuTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        
        // Define size as a percentage of the view's width and height
        let width = view.frame.width * 0.55 // 50% of the view's width
        let height = view.frame.height * 0.19 // 15% of the view's height

        loadVieww.translatesAutoresizingMaskIntoConstraints = false

        // Center X and Y
        NSLayoutConstraint.activate([
            loadVieww.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadVieww.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadVieww.widthAnchor.constraint(equalToConstant: width),
            loadVieww.heightAnchor.constraint(equalToConstant: height)
        ])
        
        // Add slight corner radius dynamically based on height
        loadVieww.layer.cornerRadius = height * 0.1
        loadVieww.layer.masksToBounds = true

        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false

        // Dynamic constraints for loadingIndicator
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: loadVieww.centerXAnchor),
            loadingIndicator.topAnchor.constraint(equalTo: loadVieww.topAnchor, constant: height * 0.15),
            loadingIndicator.widthAnchor.constraint(equalToConstant: height * 0.5),
            loadingIndicator.heightAnchor.constraint(equalToConstant: height * 0.5)
        ])

        // Dynamic constraints for loadingLabel
        NSLayoutConstraint.activate([
            loadingLabel.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: height * 0.03),
            loadingLabel.centerXAnchor.constraint(equalTo: loadVieww.centerXAnchor)
        ])


        loadingCloseButton.layer.cornerRadius = 14
        loadVieww.clipsToBounds = false
        loadingCloseButton.clipsToBounds = false
        // Constraints for the close button
        NSLayoutConstraint.activate([
            loadingCloseButton.topAnchor.constraint(equalTo: loadVieww.topAnchor, constant: -12),
            loadingCloseButton.trailingAnchor.constraint(equalTo: loadVieww.trailingAnchor, constant: 12),
            loadingCloseButton.widthAnchor.constraint(equalToConstant: 28),
            loadingCloseButton.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        
        //Code for loadinng Screen
        view.addSubview(loadImageView)
        loadImageView.addSubview(activityIndicator)
        
        loadImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loadImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        loadImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loadImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
      
        
        let bottomOffset = -0.10 * UIScreen.main.bounds.height
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 70).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomOffset).isActive = true
        
        
    }
    
    @objc func menuButtonTappedNew() {
        //self.menuButton.isHidden = true

    
        // Set the initial position of the menuTableView (off-screen to the left)
        self.menuTableView.frame = CGRect(x: -self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.menuTableView.isHidden = false

        // Animate the sliding effect
        UIView.animate(withDuration: 0.5, animations: {
            self.menuTableView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        })
    }


    
    @objc func hideMenuForBtn(_ sender: UITapGestureRecognizer) {
        self.menuButton.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            // Fade out the table view and set its alpha to 0
            self.menuTableView.alpha = 0.0
        }) { _ in
            // After the animation, hide the table view to prevent interaction
            self.menuTableView.isHidden = true
            self.menuTableView.alpha = 1.0 // Reset alpha if needed
        }
    }


    
//    @objc func hideMenuForBtn(_ sender: UITapGestureRecognizer) {
//        let location = sender.location(in: view)
//
//        // Avoid conflicting animations
//        guard !menuTableView.isAnimating else { return }
//
//        if isMenuVisible && !menuTableView.frame.contains(location) {
//            // Hide the menu
//            UIView.animate(withDuration: 0.5, animations: {
//                self.menuTableView.frame = CGRect(
//                    x: self.view.bounds.width,
//                    y: 0,
//                    width: self.menuTableView.bounds.width,
//                    height: self.menuTableView.bounds.height
//                )
//            }, completion: { _ in
//                self.menuTableView.isHidden = true
//                self.isMenuVisible = false
//                self.navigationController?.setNavigationBarHidden(false, animated: true)
//            })
//        } else if !isMenuVisible {
//            // Show the menu
//            self.menuTableView.isHidden = false
//            UIView.animate(withDuration: 0.5, animations: {
//                self.menuTableView.frame = CGRect(
//                    x: 0,
//                    y: 0,
//                    width: self.menuTableView.bounds.width,
//                    height: self.menuTableView.bounds.height
//                )
//            }, completion: { _ in
//                self.isMenuVisible = true
//                self.navigationController?.setNavigationBarHidden(true, animated: true)
//            })
//        }
//    }

    // Extension to check if the animation is ongoing
   


    
//    @objc func hideMenuForBtn(_ sender: UITapGestureRecognizer) {
//
//
//
//
//
//        if #available(iOS 16.0, *) {
//            // menuButton.isHidden = false
//        } else {
//            // Fallback on earlier versions
//        }
//        let location = sender.location(in: view)
//        if !menuTableView.frame.contains(location) {
//            // Animate the table view
//            UIView.animate(withDuration: 0.5, animations: {
//                self.menuTableView.frame = CGRect(x: self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
//                self.menuTableView.isHidden = true
//            }
//            )
//        }
//
//        if let menuImage = UIImage(named: "menu") {
//            // Get the screen width to adjust the image size dynamically
//            let screenWidth = UIScreen.main.bounds.width
//
//            // Define a base size (adjust it to your needs) and calculate the dynamic size
////            let baseSize: CGFloat = 30 // Default size for smaller screens (e.g., iPhone SE)
//            var dynamicSize = screenWidth * 0.1
//            if UIDevice.current.userInterfaceIdiom == .phone {
//                dynamicSize = screenWidth * 0.1 // 10% of screen width
//            } else if UIDevice.current.userInterfaceIdiom == .pad {
//                dynamicSize = screenWidth * 0.05 // 5% of screen width
//            }
//
//            // Resize the image to the calculated size
//            let resizedMenuImage = resizeImageNew(image: menuImage, targetSize: CGSize(width: dynamicSize, height: dynamicSize))
//
//
//            let customButton = UIButton(type: .system)
//            customButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
//
//            // Adjust the button's frame (move it down by 10 points)
//            customButton.frame = CGRect(x: 0, y: 10, width: resizedMenuImage!.size.width, height: resizedMenuImage!.size.height);
//            customButton.setImage(resizedMenuImage, for: .normal)
////
//            // Embed the button in a UIView
//            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: resizedMenuImage!.size.width, height: resizedMenuImage!.size.width))
//            containerView.addSubview(customButton)
//
//            // Create the UIBarButtonItem with the resized image
//           // let menuButton = UIBarButtonItem(image: resizedMenuImage, style: .plain, target: self, action: #selector(menuButtonTapped))
//
//            let barButtonItem = UIBarButtonItem(customView: containerView)
//            barButtonItem.tintColor = .white // Set the tint color if needed
//            navigationItem.leftBarButtonItem = barButtonItem
//            print("enable left bar button ")
//        }
//    }
    
    
    func dynamicValueClassNormal() {
        let prefs = UserDefaults.standard
        // Saving an Integer
        prefs.set(0, forKey: "ClassDynamic")

        // Logging the value
        let classDynamicValue = prefs.integer(forKey: "ClassDynamic")
        print("ClassDynamic value before \(classDynamicValue)")
    }
    
    func loadingFramesAndHelpScreen() {
        dynamicValueClassNormal()
        
        if viewController2 == nil {
            viewController2 = MainController() // Ensure MainController is properly imported in the bridging header
        }

        print("loading Frames And HelpScreen ---- notification did LoadView");
        NotificationCenter.default.post(name: Notification.Name("notificationdidLoadView"), object: nil)
        if let viewController2 = viewController2 {
            navigationController?.pushViewController(viewController2, animated: true)
        }
        self.navigationController?.navigationBar.isHidden = false
    }

    @objc func hideLoading() {
        // Remove the container view and its subviews
        //loadingContainerView?.removeFromSuperview()
        
        self.loadVieww.isHidden = true
        self.loadingLabel.isHidden = true
        self.loadingIndicator.isHidden = true
        
        // Re-enable buttons
        //startButton.isEnabled = true
        menuButton.isEnabled = true
        if #available(iOS 16.0, *) {
            self.navigationItem.leftBarButtonItem?.isHidden = false
        } else {
            // Fallback on earlier versions
        }
    }

    
    @objc func startAction() {
        
        let prefs = UserDefaults.standard
        dynamicValueClassNormal()
//        let numbers = [0]
//        let _ = numbers[1]
        if prefs.object(forKey: "FramesLoadedFirst") != nil {
            if viewController2 == nil {
                viewController2 = MainController()
            }
            print("start action ---- notification did Load View");
            NotificationCenter.default.post(name: Notification.Name("notificationdidLoadView"), object: nil)
            if let navigationController = self.navigationController {
                navigationController.pushViewController(viewController2!, animated: true)
            }
            self.navigationController?.navigationBar.isHidden = false
        } else {
            // [self showLoadingForFrames];
            // [self showingAlertViewFrames];
            loadingFramesAndHelpScreen()
        }
    }

    
    
    
    // UNUSED:
    /*
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    */
    
    @objc func menuButtonTapped() {
        if isMenuVisible {
            // Menu is already visible; hide it
            UIView.animate(withDuration: 0.5, animations: {
                self.menuTableView.frame = CGRect(
                    x: self.view.bounds.width,
                    y: 0,
                    width: self.menuTableView.bounds.width,
                    height: self.menuTableView.bounds.height
                )
            }, completion: { _ in
                self.menuTableView.isHidden = true
                self.isMenuVisible = false
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            })
        } else {
            // Menu is hidden; show it
            self.menuTableView.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.menuTableView.frame = CGRect(
                    x: 0,
                    y: 0,
                    width: self.menuTableView.bounds.width,
                    height: self.menuTableView.bounds.height
                )
            }, completion: { _ in
                self.isMenuVisible = true
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            })

            // Optional: Remove the left bar button item if needed
            self.navigationItem.leftBarButtonItem = nil
        }
    }

    
//    @objc func menuButtonTapped() {
//        self.menuTableView.isHidden = false
//        self.navigationItem.leftBarButtonItem = nil
//    }
    
    @objc func startButtonPressed() {
        print("Start Button Clicked")
        let vc = MainController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    }
    

extension StartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if SRSubscriptionModel.shareKit().isAppSubscribed() {
//            return 5
//        } else {
            return 5
       // }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuTableViewCell
        
        cell.selectionStyle = .default
        cell.backgroundColor = .clear
        //cell.textLabel?.text = "Cell \(indexPath.row)"
       // if SRSubscriptionModel.shareKit().isAppSubscribed() {
            switch(indexPath.row) {
            case 0:
                cell.menuImageView.image = UIImage(named: "optionIcon_0")
                cell.menuLabel.text = "Write Review"
            case 1:
                cell.menuImageView.image = UIImage(named: "optionIcon_1")
                cell.menuLabel.text = "Website"
            case 2:
                cell.menuImageView.image = UIImage(named: "optionIcon_2")
                cell.menuLabel.text = "Restore Purchase"
            case 3:
                cell.menuImageView.image = UIImage(named: "optionIcon_3")
                cell.menuLabel.text = "Privacy Policy"
            case 4:
                cell.menuImageView.image = UIImage(named: "optionIcon_4")
                cell.menuLabel.text = "Terms of Use"
            default:
                break
            }
        
        return cell
    }
    
    func showLoading() {
    
        // Disable buttons
      //  menuButton.isEnabled = false
        if #available(iOS 16.0, *) {
            self.navigationItem.leftBarButtonItem?.isHidden = true
        } else {
            // Fallback on earlier versions
        }
        self.loadVieww.isHidden = false
        self.loadingLabel.isHidden = false
        self.loadingIndicator.isHidden = false

    }
    
    func showLoadingForRestore() {
        showLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 40) {
            self.hideLoading()
            self.hideLoading()
        }
    }
    
    // UNUSED:
    /*
    func showSubscriptionView() {
        let subscriptionView = SimpleSubscriptionView()
        navigationController?.pushViewController(subscriptionView, animated: true)
    }
    */
    
    @objc func promptForRating() {
        
//        if #available(iOS 10.3, *) {
//            SKStoreReviewController.requestReview()
//            SKStoreReviewController.requestReviewInScene
//        } else {
//            // Fallback for earlier iOS versions
//            if let url = URL(string: "itms-apps://itunes.apple.com/app/id878108021?action=write-review") {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            }
//        }
        if #available(iOS 14.0, *) {
                // iOS 14+ uses the shared instance
                DispatchQueue.main.async {
                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        SKStoreReviewController.requestReview(in: scene)
                    }
                }
            } else {
                // For iOS 10.3 to 13.x
                SKStoreReviewController.requestReview()
            }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        menuTableView.deselectRow(at: indexPath, animated: true)
        
//        if SRSubscriptionModel.shareKit().isAppSubscribed() {
//
            switch(indexPath.row) {
                
            case 0:
                promptForRating()
                menuTableView.isHidden = true
            case 1:
                if let url = URL(string: "https://www.outthinkingindia.com") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                menuTableView.isHidden = true
            case 2:
                showLoadingForRestore()
                restoreSubscription()
                
                menuTableView.isHidden = true
            case 3:
                if let url = URL(string: "https://www.outthinkingindia.com/privacy-policy/") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                menuTableView.isHidden = true
            case 4:
                if let url = URL(string: "https://www.outthinkingindia.com/terms-of-use/") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                menuTableView.isHidden = true
            default:
                break
                
            }
//        } else {
//            switch(indexPath.row) {
//            case 0:
//                showSubscriptionView()
//                menuTableView.isHidden = true
//            case 1:
//                promptForRating()
//                menuTableView.isHidden = true
//            case 2:
//                if let url = URL(string: "https://www.outthinkingindia.com") {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                }
//                menuTableView.isHidden = true
//            case 3:
//                restoreSubscription()
//                //showLoadingForRestore()
//                menuTableView.isHidden = true
//            case 4:
//                if let url = URL(string: "https://www.outthinkingindia.com/privacy-policy/") {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                }
//                menuTableView.isHidden = true
//            case 5:
//                if let url = URL(string: "https://www.outthinkingindia.com/terms-of-use/") {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                }
//                menuTableView.isHidden = true
//            default:
//                break
//          //  }
//        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return  60
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            return 90
        }else{
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderView") as! MenuTableViewHeader
        headerView.isUserInteractionEnabled = false
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return  170
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            return 185
        }else{
            return 170
        }
    }

    
    func restoreSubscription() {
        
        SRSubscriptionModel.shareKit().restoreSubscriptions()
        showLoadingForRestore()
    }
    
}


//MARK: REMOTE CONFIG AND ADS

extension StartViewController:  FullScreenContentDelegate {
    
   @objc func remoteConfigurationSetUp() {
        // [START get_remote_config_instance]
        remoteConfig = RemoteConfig.remoteConfig()
        // [END get_remote_config_instance]

        // Create a Remote Config Setting to enable developer mode
        // [START enable_dev_mode]
        let remoteConfigSettings = RemoteConfigSettings()
        remoteConfigSettings.minimumFetchInterval = 0

        remoteConfig.configSettings = remoteConfigSettings
        // [END enable_dev_mode]

        // Set default Remote Config parameter values.
        // [START set_default_values]
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        // [END set_default_values]

        fetchConfig()
    }

    func fetchConfig() {
        print("Config value is----- \(remoteConfig.configValue(forKey: "AutoSelection").stringValue)")

        // [START fetch_config_with_callback]
        remoteConfig.fetch { status, error in
            if status == .success {
                self.remoteConfig.activate { changed, error in
                    // Fullscreen Ads
                    self.interestial_ShareString = self.remoteConfig.configValue(forKey: "Interestial_ShareScreen").stringValue
                    self.interestial_HomeButtonClickString = self.remoteConfig.configValue(forKey: "Interestial_HomeButtonClick").stringValue

                    self.interestial_Launch = self.remoteConfig.configValue(forKey: "Interestial_Launch").stringValue
                    
                    self.savingCountString = self.remoteConfig.configValue(forKey: "SavingCount").stringValue

                    self.rateUspanelString = self.remoteConfig.configValue(forKey: "rateus_panel").stringValue
                    self.subscriptionModeString = self.remoteConfig.configValue(forKey: "subscription_mode").stringValue

                    self.nativeAd_HomeString = self.remoteConfig.configValue(forKey: "native_home").stringValue

                    if let shareString = self.interestial_ShareString {
                        self.interestial_ShareCount = Int(shareString) ?? 0
                        UserDefaults.standard.set(self.interestial_ShareCount, forKey: "ShareValue")
                        print("interestial_ShareCount: \(self.interestial_ShareCount)")
                    }

                    if let homeButtonClickString = self.interestial_HomeButtonClickString {
                        self.interestial_HomeButtonClickCount = Int(homeButtonClickString) ?? 0
                        UserDefaults.standard.set(self.interestial_HomeButtonClickCount, forKey: "HomeClickValue") //s
                        print("HomeButtonClickCount: \(self.interestial_HomeButtonClickCount)")
                    }

                    if let launchString = self.interestial_Launch {
                        self.interestial_LaunchCount = Int(launchString) ?? 0
                        print("Interstitial Launch Count: \(self.interestial_LaunchCount)")
                    }


                    if let savingString = self.savingCountString {
                        self.savingCountNumber = Int(savingString) ?? 0
                        UserDefaults.standard.set(self.savingCountNumber, forKey: "SavingCountValue") //s
                        print("savingCountNumber: \(self.savingCountNumber)")
                    }

                    if let rateUsString = self.rateUspanelString {
                        self.rateUsRemoteCount = Int(rateUsString) ?? 0
                        UserDefaults.standard.set(self.rateUsRemoteCount, forKey: "RateUsValue") //s
                        print("HomeButtonClickCount: \(self.rateUsRemoteCount)")
                    }

                    if let subscriptionString = self.subscriptionModeString {
                        self.subscriptionMode = Int(subscriptionString) ?? 0
                        UserDefaults.standard.set(self.subscriptionMode, forKey: "SubCountValue") //s
                        print("subscriptionMode: \(self.subscriptionMode)")
                    }

                    if let nativeHomeString = self.nativeAd_HomeString {
                        self.native_homeCount = Int(nativeHomeString) ?? 0
                    }


                    print("Config interestial_Launch! \(self.remoteConfig.configValue(forKey: "Interestial_Launch").stringValue)")
                    print("Config interestial_Share! \(self.remoteConfig.configValue(forKey: "Interestial_ShareScreen").stringValue)")
                    print("Config interestial_ButtonClick! \(self.remoteConfig.configValue(forKey: "Interestial_HomeButtonClick").stringValue ?? "")")
                    print("Config saving Count is! \(self.remoteConfig.configValue(forKey: "SavingCount").stringValue)")
                    print("Config rateUs Count is! \(self.remoteConfig.configValue(forKey: "rateus_panel").stringValue)")
                    print("Config subscription_Mode Count is! \(self.remoteConfig.configValue(forKey: "subscription_mode").stringValue)")
                    print("Config native_homeCount is! \(self.remoteConfig.configValue(forKey: "native_home").stringValue)")
                }
            } else {
                print("Config not fetched")
                print("Error \(error?.localizedDescription ?? "No error description")")
                self.gettingInterestialCount()
            }

            let InterestialShareScreen = NSNumber(value: self.interestial_ShareCount)
            UserDefaults.standard.set(InterestialShareScreen, forKey: "Interestial_ShareScreen")

            let interestialLaunchCount = NSNumber(value: self.interestial_LaunchCount)
            UserDefaults.standard.set(interestialLaunchCount, forKey: "Interestial_Launch")

            UserDefaults.standard.set(self.interestial_HomeButtonClickCount, forKey: "Interestial_HomeButtonClick")

            let savingCount = NSNumber(value: self.savingCountNumber)
            UserDefaults.standard.set(savingCount, forKey: "SavingCount")

            let rateUsCount = NSNumber(value: self.rateUsRemoteCount)
            UserDefaults.standard.set(rateUsCount, forKey: "RateUs_Mode_Count")

            let subscriptionCount = NSNumber(value: self.subscriptionMode)
            UserDefaults.standard.set(subscriptionCount, forKey: "subscription_mode")

            let native_homeCount = NSNumber(value: self.native_homeCount)
            UserDefaults.standard.set(native_homeCount, forKey: "native_home")

            NotificationCenter.default.post(name: Notification.Name("PickerType"), object: nil)
        }
        // [END fetch_config_with_callback]
    }
    
    func gettingInterestialCount() {
        let launchInterestialCount = UserDefaults.standard.integer(forKey: "Interestial_Launch")
        let shareInterestialCount = UserDefaults.standard.integer(forKey: "Interestial_ShareScreen")
        let buttonInterestialCount = UserDefaults.standard.integer(forKey: "Interestial_HomeButtonClick")
        let rateCount = UserDefaults.standard.integer(forKey: "RateUs_Mode_Count")
        let savingCount = UserDefaults.standard.integer(forKey: "SavingCount")
        let subCount = UserDefaults.standard.integer(forKey: "subscription_mode")
        let nativeHomeCount = UserDefaults.standard.integer(forKey: "native_home")

        // Assign the values to the corresponding properties
        self.interestial_ShareCount = shareInterestialCount
        self.interestial_HomeButtonClickCount = buttonInterestialCount
        self.interestial_LaunchCount = launchInterestialCount
        self.subscriptionMode = subCount
        self.rateUsRemoteCount = rateCount
        self.savingCountNumber = savingCount
        self.native_homeCount = nativeHomeCount

        print("native_home is in View controller \(self.native_homeCount)")
        print("savingcount is in startpage controller \(self.savingCountNumber)")
        print("interestial_LaunchCount is in startpage controller \(self.interestial_LaunchCount)")
        print("interestial_ShareCount is in startpage controller \(self.interestial_ShareCount)")
        print("interestial_HomeButtonClickCount is in startpage controller \(self.interestial_HomeButtonClickCount)")
    }

    
    func gettingGdprTrackingCount() {
        let trackingCount = UserDefaults.standard.integer(forKey: "GDPR-ATT-ADS")
        self.adsTrackingCountNumber = trackingCount
    }
    
    
    func loadingShow() {
        
        
        
        if(adShowingValue == 1 && self.adsTrackingCountNumber ?? 0 > 0) {
     
               self.loadInterstitialAd()
            
            if SRSubscriptionModel.shareKit().isAppSubscribed() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                    self.dismissHud()
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 10){
                    self.dismissHud()
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.dismissHud()
            }
        }
    }
    
    
    @objc func removeLocksHere() {
        DispatchQueue.main.async {
            //self.premiumButton.isHidden = true
        }
    }
    
    func dismissHud() {
        showingConsentDialogue()
        loadImageView.isHidden = true
        activityIndicator.isHidden = true
        if let adValue = adShowingValue {
               print("Ad Showing Value Is: \(adValue)")
           } else {
               print("Ad Showing Value Is not set.")
           }
    }
    
    func showingConsentDialogue() {
        
        
        let requestParameters = RequestParameters()
        requestParameters.isTaggedForUnderAgeOfConsent = false
        requestParameters.debugSettings = DebugSettings()
        //requestParameters.debugSettings?.testDeviceIdentifiers = nil
        
        ConsentForm.loadAndPresentIfRequired(from: self) { loadAndPresentError in
            if let error = loadAndPresentError {
                // Consent gathering failed.
                print("Consent gathering failed with error: \(error.localizedDescription)")
                self.requestIDFA()
                print("Error case---")
                
                
                guard let interstitialLaunchCount = self.interstitialLaunchCount else {
                               print("interstitialLaunchCount is nil")
                               return
                           }
                           
                guard let adShowingValue = self.adShowingValue else {
                               print("adShowingValue is nil")
                               return
                           }
                           
                guard let adsTrackingCountNumber = self.adsTrackingCountNumber else {
                               print("adsTrackingCountNumber is nil")
                               return
                           }
                
                
                print("Interstitial Launch Count: \(self.interestial_LaunchCount)")
                print("Interstitial adShowingValue: \(adShowingValue)")
                print("Interstitial adsTrackingCountNumber: \(adsTrackingCountNumber)")
                
                
                
                if self.interestial_LaunchCount == 1 && adShowingValue == 1 && adsTrackingCountNumber > 0 {
                    if !SRSubscriptionModel.shareKit().isAppSubscribed() {
                        
                        DispatchQueue.main.async {
                                   self.presentInterstitialAd()
                               }
                    }
                    print("Ad is showing---")
                }
                print("Error UMP: \(error.localizedDescription)")
                return
            } else {
                
 
                self.requestIDFA()
                
//                guard let interstitialLaunchCount = self.interstitialLaunchCount else {
//                               print("interstitialLaunchCount is nil")
//                               return
//                           }
                           
                guard let adShowingValue = self.adShowingValue else {
                               print("adShowingValue is nil")
                               return
                           }
                           
                guard let adsTrackingCountNumber = self.adsTrackingCountNumber else {
                               print("adsTrackingCountNumber is nil")
                               return
                           }
                
                print("Success case---")
                print("Interstitial Launch Count: \(self.interestial_LaunchCount)")
                print("Interstitial adShowingValue: \(adShowingValue)")
                print("Interstitial adsTrackingCountNumber: \(adsTrackingCountNumber)")
                
                
                
                if self.interestial_LaunchCount == 1 && adShowingValue == 1 && adsTrackingCountNumber > 0 {
                    if !SRSubscriptionModel.shareKit().isAppSubscribed() {
                        DispatchQueue.main.async {
                                   self.presentInterstitialAd()
                               }
                    }
                    print("Ad is showing---")
                }
                print("Requesting ATT App Tracking here-----")
            }
            // Consent has been gathered.
        }
    }
    
    func presentInterstitialAd() {
        if let interstitial = interstitial {
            interstitial.present(from: self)
            loadImageView.isHidden = true
            activityIndicator.isHidden = true
        } else {
            print("Interstitial ad wasn't ready")
            loadImageView.isHidden = true
            activityIndicator.isHidden = true
        }
    }
    
    func loadInterstitialAd() {
        let request = Request()
        InterstitialAd.load(with: "ca-app-pub-8572140050384873/4407210680", request: request) { [weak self] ad, error in
            guard let self = self else { return }
            if let error = error {
                print("Failed to load interstitial ad: \(error.localizedDescription)")
                loadImageView.isHidden = true
                activityIndicator.isHidden = true
                return
            }
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
            // Ad is loaded and ready to be presented when needed
            print("Interstitial ad loaded successfully")
        }
    }
    
    func newConsentDialogue() {
        print("Requesting UMP")
        
        // Create UMPRequestParameters
        let parameters = RequestParameters()
        
        // Create UMPDebugSettings and set test device identifiers
        let debugSettings = DebugSettings()
        //debugSettings.testDeviceIdentifiers = [uniqueIdentifier] // Replace uniqueIdentifier with your actual test device identifier
        
        if let identifier = uniqueIdentifier {
               debugSettings.testDeviceIdentifiers = [identifier]
           } else {
               print("Device identifier is nil")
           }
           
        
        // Set geography to EEA (European Economic Area)
       //debugSettings.geography = .EEA
        
        parameters.debugSettings = debugSettings
        
        // Request consent info update with parameters
        ConsentInformation.shared.requestConsentInfoUpdate(with: parameters) { error in
            if let error = error {
                // Handle error if consent info update request fails
                print("Consent info update request failed with error: \(error.localizedDescription)")
            } else {
                // Consent info update request successful
                print("Consent info update request successful")
                // Handle logic after successful consent info update
            }
        }
    }
    
    func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                // Tracking authorization completed. Start loading ads here.
                switch status {
                case .authorized:
                    print("Ads Access Given---")
                    UserDefaults.standard.set(1, forKey: "GDPR-ATT-ADS")
                    DispatchQueue.main.async {
                        self.startButton.isUserInteractionEnabled = true
                    }
                    
                case .denied:
                    print("Ads Access Denied---")
                    UserDefaults.standard.set(1, forKey: "GDPR-ATT-ADS")
                    DispatchQueue.main.async {
                        self.startButton.isUserInteractionEnabled = true
                    }
                case .restricted:
                    print("Ads Access Restricted---")
                    DispatchQueue.main.async {
                        self.startButton.isUserInteractionEnabled = true
                    }
                case .notDetermined:
                    print("Ads Access not determined---")
                    DispatchQueue.main.async {
                        self.startButton.isUserInteractionEnabled = true
                    }
                @unknown default:
                    print("Unknown authorization status")
                    DispatchQueue.main.async {
                        self.startButton.isUserInteractionEnabled = true
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
        loadImageView.isHidden = true
        activityIndicator.isHidden = true
    }

//    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        print("Ad did present full screen content.")
//    }
    
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        loadInterstitialAd()
        print("Ad did dismiss full screen content.")
    }
}



class DotIndicatorView: UIView {
    
    private let dotSize: CGFloat = 10
    private let dotSpacing: CGFloat = 8
    private let dotColor: UIColor = .white
    private var dots: [UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDots()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDots()
    }
    
    private func setupDots() {
        for _ in 0..<3 {
            let dot = UIView()
            dot.backgroundColor = dotColor
            dot.layer.cornerRadius = dotSize / 2
            dot.translatesAutoresizingMaskIntoConstraints = false
            addSubview(dot)
            dots.append(dot)
        }
        setupConstraints()
        startAnimating()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dots[0].centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -dotSize - dotSpacing),
            dots[1].centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dots[2].centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: dotSize + dotSpacing)
        ])
        
        dots.forEach { dot in
            NSLayoutConstraint.activate([
                dot.widthAnchor.constraint(equalToConstant: dotSize),
                dot.heightAnchor.constraint(equalToConstant: dotSize),
                dot.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        }
    }
    
    private func startAnimating() {
        let animationDuration: CFTimeInterval = 1.0
        let delayInterval: CFTimeInterval = 0.3
        
        for (index, dot) in dots.enumerated() {
            let delay = Double(index) * delayInterval
            
            // Create opacity animation
            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = 1.0
            opacityAnimation.toValue = 0.3
            opacityAnimation.duration = animationDuration
            opacityAnimation.autoreverses = true
            opacityAnimation.repeatCount = .infinity
            
            // Create scale animation
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 1.0
            scaleAnimation.toValue = 1.3
            scaleAnimation.duration = animationDuration
            scaleAnimation.autoreverses = true
            scaleAnimation.repeatCount = .infinity
            
            // Create position bounce animation
            let positionAnimation = CABasicAnimation(keyPath: "position.y")
            positionAnimation.byValue = -5 // Move up by 5 points
            positionAnimation.duration = animationDuration
            positionAnimation.autoreverses = true
            positionAnimation.repeatCount = .infinity
            positionAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            // Group animations
            let animationGroup = CAAnimationGroup()
            animationGroup.animations = [opacityAnimation, scaleAnimation, positionAnimation]
            animationGroup.duration = animationDuration
            animationGroup.beginTime = CACurrentMediaTime() + delay
            animationGroup.repeatCount = .infinity
            
            dot.layer.add(animationGroup, forKey: "dotAnimation")
        }
    }
}


// UNUSED:
/*
extension UIView {
    var isAnimating: Bool {
        return layer.animationKeys()?.isEmpty == false
    }
}
*/

extension StartViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Check if the touch is inside the menuTableView
        if menuTableView.frame.contains(touch.location(in: view)) {
            return false // Prevent the gesture from triggering
        }
        return true // Allow the gesture elsewhere
    }
}

