//
//  AdjustOptionsViewController.swift
//  VideoFrames
//
//  Sub-tabbar for Adjust mode: Speed and Trim options
//

import Foundation
import UIKit

class AdjustOptionsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var optionsList: [Option] = []
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let topAnchorConstant: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 12 : 8
    let viewHeight: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 90 : 70

    private func loadData() {
        let customColor = UIColor(red: 25.0/255.0, green: 184.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)

        // Adjust TabBar: Speed, Trim

        // Speed - speedometer icon
        if let systemImage = UIImage(systemName: "speedometer", withConfiguration: config) {
            let whiteImage = systemImage.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
            let selectedImage = systemImage.withTintColor(customColor, renderingMode: .alwaysOriginal)
            optionsList.append(Option(name: "Speed", image: whiteImage, selectedImage: selectedImage))
        }

        // Trim - scissors icon
        if let systemImage = UIImage(systemName: "scissors", withConfiguration: config) {
            let whiteImage = systemImage.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
            let selectedImage = systemImage.withTintColor(customColor, renderingMode: .alwaysOriginal)
            optionsList.append(Option(name: "Trim", image: whiteImage, selectedImage: selectedImage))
        }
    }

    var optionsLayout: UICollectionViewFlowLayout!
    private var optionsCollectionView: UICollectionView!

    private var backButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        if let image = UIImage(systemName: "chevron.left", withConfiguration: config) {
            btn.setImage(image, for: .normal)
        }
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("--- AdjustOptionsViewController.swift: viewDidLoad ---")
        let user_default_color = UIColor(red: 28/255.0, green: 32/255.0, blue: 38/255.0, alpha: 1.0)
        view.backgroundColor = user_default_color
        view.layer.cornerRadius = 20

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotification(_:)),
                                               name: NSNotification.Name("resetSelectedItems"),
                                               object: nil)
        loadData()
        setupBackButton()
        setupCollectionViews()
    }

    private func setupBackButton() {
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: topAnchorConstant),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: viewHeight)
        ])
    }

    @objc private func backButtonTapped() {
        // Notify to go back to photo action tabbar
        let myNotificationName = Notification.Name("adjustOptionsBack")
        NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: nil)
    }

    @objc func handleNotification(_ notification: Notification) {
        resetAllSelectedOptions()
    }

    func resetAllSelectedOptions() {
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

        optionsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: optionsLayout)
        optionsCollectionView.isPagingEnabled = false
        optionsCollectionView.backgroundColor = .clear
        optionsCollectionView.register(OptionsCell.self, forCellWithReuseIdentifier: OptionsCell.identifier)

        optionsCollectionView.delegate = self
        optionsCollectionView.dataSource = self
        view.addSubview(optionsCollectionView)
        optionsCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            optionsCollectionView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 5),
            optionsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            optionsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: topAnchorConstant),
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
        let myNotificationName = Notification.Name("adjustActionSelected")
        let params: [String: Any] = ["action": selectedOption.name]
        NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: params)
    }

    func isiPod() -> Bool {
        let device = UIDevice.current
        return device.userInterfaceIdiom == .phone && UIScreen.main.bounds.height == 568
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numofitemsforScreen = 2  // We have exactly 2 items: Speed, Trim
        var reminder: CGFloat = 0

        if UIDevice.current.userInterfaceIdiom == .pad {
            numofitemsforScreen = 2
            reminder = 0
        } else if isiPod() {
            reminder = 0.65
            numofitemsforScreen = 2
        } else {
            numofitemsforScreen = 2
            reminder = 0.6
        }

        let spacing = 8
        let availableWidth = collectionView.bounds.width - CGFloat(numofitemsforScreen * spacing)
        let itemwidth = availableWidth / (CGFloat(numofitemsforScreen) + reminder)

        return CGSize(width: itemwidth, height: collectionView.bounds.height - 10)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
