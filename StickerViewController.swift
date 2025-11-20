// StickerViewController.swift
// AIEraseObjects
//
// Created by Admin on 23/01/25.
//

protocol StickerViewControllerDelegate: AnyObject {
    func didSelectSticker(_ sticker: String)
}

import UIKit

class StickerViewController: UIViewController, UIScrollViewDelegate,UITextFieldDelegate,UISearchBarDelegate {
   
    
    var topView: ShadowContainerView = {
        let view = ShadowContainerView()
        let user_default_color =  UIColor(red:28/255.0, green:32/255.0 , blue:38/255.0, alpha:1.0)
        view.backgroundColor = user_default_color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var lineView: UIView = {
        let view = UIView()
        let color = UIColor(red: 48.0/255.0, green: 51.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        view.backgroundColor = color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var line_View: UIView = {
        let view = UIView()
        let color = UIColor(red: 48.0/255.0, green: 51.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        view.backgroundColor = color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var heightOfsearchField : CGFloat = 40
    var heightOfTitleBar : CGFloat = 60
    let offset : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 10 : 5
    weak var delegate: StickerViewControllerDelegate?
    var allStickerfileNames:[String] = []
    // UNUSED: var categories: [String] = []
    // UNUSED: var categorizedImages: [String: [ImageAsset]] = [:]
    // UNUSED: var stickerArray: [String] = []
    // var listCategory :ListCategory
   // var categoryElements:[CategoryElement] = []
    var stickerData: StickerData?
    let user_default_color =  UIColor(red:28/255.0, green:32/255.0 , blue:38/255.0, alpha:1.0)
    var filteredFilenames: [String] = []
//    var closeImageView: UIImageView = {
//        let imgV = UIImageView()
//        imgV.isUserInteractionEnabled = true
//        imgV.image = UIImage(named: "done2")
//        imgV.tintColor = .gray
//        imgV.translatesAutoresizingMaskIntoConstraints = false
//        return imgV
//    }()
    
    private var selectedCategoryIndex: Int = 0
      private var currentMainCollectionIndex: Int = 0 {
             didSet {
                 // Update bottom collection when index changes
                 let previousIndexPath = IndexPath(item: oldValue, section: 0)
                 let newIndexPath = IndexPath(item: currentMainCollectionIndex, section: 0)
                 
                 // Update cell borders
                 bottomCollectionView.reloadItems(at: [previousIndexPath, newIndexPath])
                 
                 // Scroll bottom collection to new index
                 bottomCollectionView.scrollToItem(
                     at: newIndexPath,
                     at: .centeredHorizontally,
                     animated: true
                 )
             }
         }
    
    private let noResultLabel: UILabel = {
            let label = UILabel()
            label.text = "No results found"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
            label.textColor = .gray
            label.isHidden = true
            return label
        }()
    
    
    var searchButton: UIImageView = {
        let btn = UIImageView()
        btn.tintColor = .white
        btn.backgroundColor = .clear
        btn .image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
      //  btn.setImage(UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        btn.isUserInteractionEnabled = true
        btn.contentMode = .scaleAspectFit
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
   
    var searchTapView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var backButton: UIImageView = {
        let btn = UIImageView()
        btn.tintColor = .white
        btn.backgroundColor = .clear
        btn .image = UIImage(systemName: "arrow.backward")?.withRenderingMode(.alwaysTemplate)
      //  btn.setImage(UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        btn.isUserInteractionEnabled = true
        btn.contentMode = .scaleAspectFit
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let searchTextField : UITextField =
    {
        let textField = UITextField()
        textField.placeholder = "Enter search text..."
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter search text...",
            attributes: [
                .foregroundColor: UIColor.lightGray.withAlphaComponent(0.9)
            ]
        )
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white.withAlphaComponent(0.25)
        textField.textColor = .white
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    var searchTextFieldHeightConstraint: NSLayoutConstraint!
    
    
    var titleLable: UILabel = {
        let lbl = UILabel()
        lbl.text = "Stickers"
        lbl.textColor = .lightGray
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "Gilroy-Medium", size: (UIDevice.current.userInterfaceIdiom == .pad) ? 20 : 15)//UIFont.systemFont(ofSize: 15, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var bottomView: UIView = {
        let view = UIView()
        let user_default_color =  UIColor(red:28/255.0, green:32/255.0 , blue:38/255.0, alpha:1.0)
        view.backgroundColor = user_default_color
        view.translatesAutoresizingMaskIntoConstraints = false
        // Add shadow for 3D effect
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 0, height: -3)
        view.layer.shadowRadius = 6
        view.layer.cornerRadius = 8  // Subtle corner radius
        return view
    }()
    
    var mainCollectionView: UICollectionView!
    var filteredcollectionView: UICollectionView!
    
    var bottomCollectionView: UICollectionView!
    
   // var collectionView: UICollectionView!
  //  let searchBar = UISearchBar()
    // Called when the user finishes editing
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        print("TextField did end editing: \(textField.text ?? "")")
        if textField.text!.isEmpty {
            filteredFilenames = allStickerfileNames
        } else {
            filteredFilenames = []
            filteredcollectionView.reloadData()
            let trimmedString = textField.text!.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            let whiteSpacerRemovedString = trimmedString.replacingOccurrences(of: " ", with: "")
            print("whiteSpacerRemovedString",whiteSpacerRemovedString)
            filteredFilenames = allStickerfileNames.filter { $0.lowercased().contains(whiteSpacerRemovedString) }
            print("filtered names are ",filteredFilenames)
        }
        noResultLabel.isHidden = !filteredFilenames.isEmpty
        filteredcollectionView.isHidden = false
        filteredcollectionView.reloadData()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
//        if textField.text!.isEmpty {
//            filteredFilenames = allStickerfileNames
//        } else {
//            filteredFilenames = []
//            filteredcollectionView.reloadData()
//            let trimmedString = textField.text!.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
//            let whiteSpacerRemovedString = trimmedString.replacingOccurrences(of: " ", with: "")
//            print("whiteSpacerRemovedString",whiteSpacerRemovedString)
//            filteredFilenames = allStickerfileNames.filter { $0.lowercased().contains(whiteSpacerRemovedString) }
//            print("filtered names are ",filteredFilenames)
//        }
//        noResultLabel.isHidden = !filteredFilenames.isEmpty
//        filteredcollectionView.isHidden = false
//        filteredcollectionView.reloadData()
            return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder() // Dismiss keyboard
        if textField.text!.isEmpty {
            filteredFilenames = [] //allStickerfileNames
        } else {
            filteredFilenames = []
            filteredcollectionView.reloadData()
            let trimmedString = textField.text!.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            let whiteSpacerRemovedString = trimmedString.replacingOccurrences(of: " ", with: "")
            print("whiteSpacerRemovedString",whiteSpacerRemovedString)
            filteredFilenames = allStickerfileNames.filter { $0.lowercased().contains(whiteSpacerRemovedString) }
            print("filtered names are ",filteredFilenames)
        }
        noResultLabel.isHidden = !filteredFilenames.isEmpty
        filteredcollectionView.isHidden = false
        filteredcollectionView.reloadData()
            return true
    }
   
    
    func applySubtle3DTransformToBottomView() {
        // Add subtle 3D shadow to the bottom view for a smooth, refined look
        bottomView.layer.shadowOpacity = 0.2  // Slightly lighter shadow
        bottomView.layer.shadowOffset = CGSize(width: 0, height: -4)  // More subtle shadow offset
        bottomView.layer.shadowRadius = 4  // Smaller shadow radius
        bottomView.layer.cornerRadius = 8  // Rounded corners for smoothness
        
        // Lift the bottom view slightly for a floating effect
        let transform = CATransform3DMakeTranslation(0, 5, 0)  // Slightly lift the view for a subtle floating effect
        bottomView.layer.transform = transform
    }
    
    func applySubtle3DTransformToCollectionView() {
        // For a subtle 3D effect on the collection view
        mainCollectionView.layer.shadowColor = UIColor.black.cgColor
        mainCollectionView.layer.shadowOpacity = 0.2  // Lighter shadow
        mainCollectionView.layer.shadowOffset = CGSize(width: 0, height: 2)  // Small vertical offset for a subtle effect
        mainCollectionView.layer.shadowRadius = 6  // Smaller shadow radius for subtle effect
        mainCollectionView.layer.cornerRadius = 0// Slightly rounded corners for smoothness
        
        // Apply a subtle lift effect
        let transform = CATransform3DMakeTranslation(0, 3, 0)  // Slight lift for a subtle 3D effect
        mainCollectionView.layer.transform = transform
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadDataFromJSON()
        
    }
    
    func loadDataFromJSON()
    {
        if let url = Bundle.main.url(forResource: "sticker", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url, options: .mappedIfSafe) // ✅ Use `url` directly
                self.stickerData = try JSONDecoder().decode(StickerData.self, from: data)
                
                // Print the decoded data
                if let stickerData = self.stickerData {
                    print("Decoded Sticker Data:")
                    for category in stickerData.categories {
//                        var stickerNames :[String] = []
//                        for i in 0...category.count
//                        {
//                            let stickerName  = category.prefix+String(i)
//                            stickerNames.append(stickerName)
//                            print("load data Sticker name is ",stickerName)
//                        }
//                        categoryElements.append(CategoryElement(name: category.categoryName, stickerNames: stickerNames))
                        allStickerfileNames.append(contentsOf: category.stickers)
                        print("Category: \(category.categoryName)")
//                        print("Stickers prefix: \(category.prefix)")
//                        print("Stickers count : \(category.count)")
                    }
                    //filteredFilenames = allStickerfileNames
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        } else {
            print("sticker.json NOT found in bundle!")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if((UIDevice.current.userInterfaceIdiom == .pad) )
        {
            heightOfTitleBar = 75
        }
        else if(isiPod())
        {
            heightOfTitleBar = 40
        }
        else
        {
            heightOfTitleBar = UIScreen.main.bounds.height*0.06
        }
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = user_default_color //UIColor.systemGray6.withAlphaComponent(1.0)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = view.bounds.size // Use bounds only when the view has been laid out
        // Full-screen for each "page"
        layout.scrollDirection = .horizontal // Horizontal scrolling for the main collection view
        layout.minimumLineSpacing = 0 // No space between pages
        layout.sectionInset = UIEdgeInsets.zero
        
        mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
        mainCollectionView.backgroundColor = user_default_color
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        mainCollectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "MainCell")
        mainCollectionView.tag = 1
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
        mainCollectionView.isPagingEnabled = true // Enable paging effect
        
        
        let bottomLayout = UICollectionViewFlowLayout()
       // bottomLayout.itemSize = CGSize(width: 50, height: 50) // Different size for bottom items
        bottomLayout.minimumInteritemSpacing = 35 // Different horizontal spacing
        bottomLayout.minimumLineSpacing = 30 // Different vertical spacing
        bottomLayout.scrollDirection = .horizontal // Horizontal scrolling for bottom collection
        bottomLayout.sectionInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        bottomLayout.minimumInteritemSpacing = 30
        
        bottomCollectionView = UICollectionView(frame: .zero, collectionViewLayout: bottomLayout)
        bottomCollectionView.translatesAutoresizingMaskIntoConstraints = false
        bottomCollectionView.backgroundColor = .clear
        bottomCollectionView.dataSource = self
        bottomCollectionView.delegate = self
        bottomCollectionView.register(BottomCollectionViewCell.self, forCellWithReuseIdentifier: "BottomCell")
        bottomCollectionView.layer.cornerRadius = 5
        bottomCollectionView.tag = 2
        bottomCollectionView.showsHorizontalScrollIndicator = false
        
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

       
        let filteredlayout = UICollectionViewFlowLayout()
        filteredlayout.itemSize = CGSize(width: 100, height: 100)
        filteredlayout.minimumInteritemSpacing = 10
        filteredlayout.minimumLineSpacing = 10
        
        filteredcollectionView = UICollectionView(frame: .zero, collectionViewLayout: filteredlayout)
        filteredcollectionView.backgroundColor = user_default_color //UIColor(hue: 0.0, saturation: 0.0, brightness: 0.18, alpha: 1.0)
        filteredcollectionView.dataSource = self
        filteredcollectionView.delegate = self
        filteredcollectionView.tag = 3
        filteredcollectionView.register(FilteredStickerCell.self, forCellWithReuseIdentifier: FilteredStickerCell.identifier)
        filteredcollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(topView)
        topView.addSubview(titleLable)
        //view.addSubview(closeImageView)
        topView.addSubview(searchButton)
        topView.addSubview(searchTapView)
        topView.addSubview(backButton)
        topView.addSubview(searchTextField)
        topView.addSubview(lineView)
        view.addSubview(mainCollectionView)
        
        view.addSubview(bottomView)
        bottomView.addSubview(bottomCollectionView)
        bottomView.addSubview(line_View)
        
        view.addSubview(filteredcollectionView)
        
        noResultLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noResultLabel)
        
        backButton.isHidden = true
        searchTextField.isHidden = true
        noResultLabel.isHidden = true
        filteredcollectionView.isHidden = true
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeButtonTapped))
//          closeImageView.addGestureRecognizer(tapGesture)
        
        let tap_gestureSearchIcon = UITapGestureRecognizer(target: self, action: #selector(showSearchField))
        let tap_gestureSearchBar = UITapGestureRecognizer(target: self, action: #selector(showSearchField))
        searchButton.addGestureRecognizer(tap_gestureSearchIcon)
        searchTapView.addGestureRecognizer(tap_gestureSearchBar)
        
        let backTapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        backButton.addGestureRecognizer(backTapGesture)
        
        setUpConstraints()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
            print("Text changed: \(textField.text ?? "")")
        if textField.text!.isEmpty {
            filteredFilenames = allStickerfileNames
        } else {
            filteredFilenames = []
            filteredcollectionView.reloadData()
            let trimmedString = textField.text!.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            let whiteSpacerRemovedString = trimmedString.replacingOccurrences(of: " ", with: "")
            print("whiteSpacerRemovedString",whiteSpacerRemovedString)
            filteredFilenames = allStickerfileNames.filter { $0.lowercased().contains(whiteSpacerRemovedString) }
            print("filtered names are ",filteredFilenames)
        }
        noResultLabel.isHidden = !filteredFilenames.isEmpty
        filteredcollectionView.isHidden = false
        filteredcollectionView.reloadData()
    }
    
    
    @objc func backButtonTapped()
    {
        print("back button tapped")
        searchTextField.resignFirstResponder()
        backButton.isHidden = true
        searchButton.isHidden = false
        searchTapView.isHidden = false
        titleLable.isHidden = false
        searchTextField.text = ""
        filteredFilenames = []
        self.searchTextFieldHeightConstraint.isActive = false
           UIView.animate(withDuration: 0.3) {
               self.searchTextFieldHeightConstraint.constant = 0
               self.searchTextFieldHeightConstraint.isActive = true// Expand field height
               self.view.layoutIfNeeded()
           }
        noResultLabel.isHidden = true
        searchTextField.isHidden = true
        filteredcollectionView.isHidden = true
    }
    
    @objc func showSearchField() {
        print("search clicked")
        self.searchTextFieldHeightConstraint.isActive = false
        UIView.animate(withDuration: 0.3) {
            self.searchTextFieldHeightConstraint.constant = self.heightOfsearchField
               self.searchTextFieldHeightConstraint.isActive = true// Expand field height
               self.view.layoutIfNeeded()
        }
        self.searchButton.isHidden = true
        self.searchTapView.isHidden = true
        self.titleLable.isHidden = true
        self.backButton.isHidden = false
        self.searchTextField.isHidden = false
        self.searchTextField.becomeFirstResponder() // Open keyboard
       }
    


    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            self.mainCollectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
    
    
    
    override func viewWillLayoutSubviews() {
        // Apply 3D effects
        DispatchQueue.main.async {
            
            self.applySubtle3DTransformToBottomView()
            self.applySubtle3DTransformToCollectionView()
        }
        
        if let visibleCells = mainCollectionView.visibleCells as? [MainCollectionViewCell] {
            for cell in visibleCells {
                cell.updateLayout()
                UIView.performWithoutAnimation {
                    let transition = CATransition()
                    transition.type = .fade
                    transition.duration = 0.5
                    mainCollectionView.layer.add(transition, forKey: "UICollectionViewReloadAnimation")
                    mainCollectionView.reloadData()
                    
                }
            }
        }
    }
    
    func setUpConstraints() {
        heightOfsearchField = heightOfTitleBar - 3*offset
        topView.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        line_View.translatesAutoresizingMaskIntoConstraints = false
        
//        let widthOfItems = 50.0;
        var sizeOfbutton: CGFloat = 35
        if(UIDevice.current.userInterfaceIdiom == .pad )
        {
            sizeOfbutton = 35
        }
        else if(isiPod())
        {
            sizeOfbutton = 25
        }
        else
        {
             sizeOfbutton = 30
        }
        let sizeOfbottomView: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 100 : 75
        NSLayoutConstraint.activate([
            
            topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            topView.heightAnchor.constraint(equalToConstant: heightOfTitleBar),
            
            titleLable.widthAnchor.constraint(equalToConstant: 150),
            titleLable.heightAnchor.constraint(equalToConstant: heightOfTitleBar),
            titleLable.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            titleLable.centerYAnchor.constraint(equalTo:topView.centerYAnchor,constant: offset),
            
            lineView.topAnchor.constraint(equalTo: topView.bottomAnchor,constant: 0),
            lineView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            
            searchButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            searchButton.centerYAnchor.constraint(equalTo: titleLable.centerYAnchor,constant: -5),
            searchButton.widthAnchor.constraint(equalToConstant: sizeOfbutton),
            searchButton.heightAnchor.constraint(equalToConstant: sizeOfbutton),
            
            searchTapView.leadingAnchor.constraint(equalTo: searchButton.trailingAnchor , constant: 1),
            searchTapView.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: 5),
            searchTapView.heightAnchor.constraint(equalToConstant: sizeOfbutton),
            searchTapView.centerYAnchor.constraint(equalTo: searchButton.centerYAnchor),
            
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.centerYAnchor.constraint(equalTo: titleLable.centerYAnchor,constant: -5),
            backButton.heightAnchor.constraint(equalToConstant: sizeOfbutton),
            backButton.widthAnchor.constraint(equalToConstant: sizeOfbutton),
            
            searchTextField.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 20),
            //searchTextField.centerYAnchor.constraint(equalTo: titleLable.centerYAnchor,constant: offset),
            searchTextField.topAnchor.constraint(equalTo: topView.topAnchor, constant: 12),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant:heightOfsearchField),
            
              
            
            mainCollectionView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 8),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mainCollectionView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: 7),
            
            filteredcollectionView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 8),
            filteredcollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            filteredcollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            filteredcollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 7),
            
            noResultLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            noResultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            noResultLabel.widthAnchor.constraint(equalToConstant: view.bounds.width),
            noResultLabel.heightAnchor.constraint(equalToConstant: 100),
            
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            bottomView.heightAnchor.constraint(equalToConstant: sizeOfbottomView),
            
            bottomCollectionView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 0),
            bottomCollectionView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            bottomCollectionView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            bottomCollectionView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor,constant: -15),
            
            line_View.topAnchor.constraint(equalTo: bottomView.topAnchor,constant: 1),
            line_View.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            line_View.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            line_View.heightAnchor.constraint(equalToConstant: 1)
        ])
        // Initially hide search field by setting height to 0
        searchTextFieldHeightConstraint = searchTextField.heightAnchor.constraint(equalToConstant: 0)
        searchTextFieldHeightConstraint.isActive = true
    }
    
    func didSelectSticker(_ sticker: String) {
            // Notify the delegate (ShareStickerViewController)
            delegate?.didSelectSticker(sticker)
        // Define a constant for the notification name
        let myNotificationName = Notification.Name("AddSticker")
        let params: [String: Any] = ["StickerImageName": sticker]
        NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: params)
//        dismiss(animated: true, completion: nil)
//        MoveUINormal()
        searchTextField.resignFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let sheet = self.sheetPresentationController
            {
                sheet.animateChanges {
                    if sheet.selectedDetentIdentifier == .large
                    {
                        sheet.selectedDetentIdentifier = .medium
                    }
                }
            }
        }
    }
    
    func MoveUINormal()
    {
        let myNotificationName = Notification.Name("BringUIBacktoNormal")
        NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: nil)
    }
    
    @objc func closeButtonTapped() {
        print("close button tapped")
        self.dismiss(animated: true)
        MoveUINormal()
    }
}

extension StickerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("stickerData?.categories.count : \(stickerData?.categories.count)")
        
        if collectionView.tag == 1 {
            return (stickerData?.categories.count)!
            
        } else   if collectionView.tag == 2{
            return (stickerData?.categories.count)!
        }
        else if collectionView.tag == 3
        {
            return filteredFilenames.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: indexPath) as? MainCollectionViewCell else {
                      fatalError("Unable to dequeue MainCollectionViewCell")
                  }
            
            if let category = stickerData?.categories[indexPath.row] {
                        cell.configure(with: category)
                    }
         //   cell.configure(with: categoryElements[indexPath.row])
            return cell
        }
        else if collectionView.tag == 2 {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomCell", for: indexPath) as? BottomCollectionViewCell else {
                        fatalError("Unable to dequeue BottomCollectionViewCell")
                    }
                    
                    let firstStickerName = stickerData!.categories[indexPath.row].stickers[0]
                    cell.imageView.image = UIImage(named: firstStickerName)

                    // Update selection state based on current index
                  //  cell.layer.borderWidth = indexPath.item == currentMainCollectionIndex ? 2 : 0
                   // cell.layer.borderColor = UIColor.systemBlue.cgColor
                    
                    // Show top border only for selected index
                       let isSelected = indexPath.item == currentMainCollectionIndex
                       cell.updateSelection(isSelected: isSelected)
                    
                    
                    return cell
                } 
        
//        else if collectionView.tag == 2 {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomCell", for: indexPath) as? BottomCollectionViewCell else {
//                            fatalError("Unable to dequeue BottomCollectionViewCell")
//                        }
//                        
//                        let firstStickerName = stickerData!.categories[indexPath.row].stickers[0]
//                        cell.imageView.image = UIImage(named: firstStickerName)
//
//                        // Update selection state based on current index
//                        cell.layer.borderWidth = indexPath.item == currentMainCollectionIndex ? 2 : 0
//                        cell.layer.borderColor = UIColor.systemBlue.cgColor
//                        
//                        return cell
//        }
        else if collectionView.tag == 3
        {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilteredStickerCell.identifier, for: indexPath) as! FilteredStickerCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:FilteredStickerCell.identifier, for: indexPath) as! FilteredStickerCell
            if(indexPath.row < filteredFilenames.count)
            {
                let stickerName = filteredFilenames[indexPath.row]
                cell.imageView.image = UIImage(named: stickerName)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 2 { // Bottom collection view selected
              let correspondingIndex = indexPath.row

              // Scroll the MainCollectionView to the corresponding category
              let mainIndexPath = IndexPath(item: correspondingIndex, section: 0)
              mainCollectionView.scrollToItem(at: mainIndexPath, at: .centeredHorizontally, animated: true)

              // Update the bottom collection view selection
              bottomCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
              
              // Optionally, you can reload the bottom collection view to update the border
              bottomCollectionView.reloadData()
          }
        else if collectionView.tag == 3
        {
            didSelectSticker(filteredFilenames[indexPath.row])
        }
    }
    
    func isiPod() -> Bool {
        let device = UIDevice.current
        return device.userInterfaceIdiom == .phone && UIScreen.main.bounds.height == 568
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mainCollectionView {
               // Set size for cells in the main collection view
            return CGSize(width: mainCollectionView.frame.width, height: mainCollectionView.frame.height)
        }
        else if collectionView == filteredcollectionView
        {
            return CGSize(width: 100, height: 100)
        }
        else
        {
            var spacing: CGFloat = 60 // Adjust spacing between cells as needed
            // Set size for cells in the bottom collection view
            var totalItems = 5
            if UIDevice.current.userInterfaceIdiom == .pad
            {
                spacing = 65
                totalItems = 8
            }
            else if(isiPod())
            {
                spacing = 10
                totalItems = 8
            }
            else
            {
                spacing = 20
                totalItems = 6
            }
               
               let totalSpacing = CGFloat(totalItems - 1) * spacing
               let availableWidth = collectionView.bounds.width - totalSpacing
               let itemWidth = availableWidth / CGFloat(totalItems)
               return CGSize(width: itemWidth, height: collectionView.bounds.height-20 )
        }
           return CGSize.zero
    }
  

    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if scrollView == mainCollectionView {
//            let currentIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
//            
//            // Ensure the index is within bounds
//            guard currentIndex < categories.count else { return }
//
//            // Update the bottom collection view data
//            let selectedCategory = categories[currentIndex]
//            let newStickers = categorizedImages[selectedCategory] ?? []
//            
//            // Update data source for bottomCollectionView
//            self.stickerArray = newStickers.map { $0.fileName }  // Adjust based on your ImageAsset structure
//            let indexPath = IndexPath(item: currentIndex, section: 0)
//            bottomCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
//            
//            // Optionally, you can reload the bottom collection view to update the border
//            bottomCollectionView.reloadData()
//        }
//    }

}



extension StickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    // UIImagePickerControllerDelegate method to handle the image selection
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)  // Ensure picker is dismissed when canceled
    }
}


extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

extension StickerViewController {


    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            guard scrollView == mainCollectionView else { return }
            
            let pageWidth = scrollView.frame.width
            let currentPage = Int(round(scrollView.contentOffset.x / pageWidth))
            
            if currentPage != currentMainCollectionIndex {
                currentMainCollectionIndex = currentPage
            }
        }


    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            guard scrollView == mainCollectionView else { return }
            // Final synchronization
            let currentPage = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
            currentMainCollectionIndex = currentPage
        }


    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == mainCollectionView {
            let currentIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
            if currentIndex != selectedCategoryIndex {
                let previousIndex = selectedCategoryIndex
                selectedCategoryIndex = currentIndex
                let indexPaths = [IndexPath(item: previousIndex, section: 0), IndexPath(item: currentIndex, section: 0)]
                bottomCollectionView.reloadItems(at: indexPaths)
                bottomCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }
}
