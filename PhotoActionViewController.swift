//
//  PhotoActionViewController.swift
//  VideoFrames
//
//  Tabbar showing Replace/Adjust/Delete when photo is selected (green outline)
//

import Foundation
import UIKit

class PhotoActionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var optionsList: [Option] = []
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let topAnchorConstant: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 12 : 8
    let viewHeight: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 90 : 70

    // Property to determine if slot is empty (shows "Add") or filled (shows "Replace")
    @objc var isEmptySlot: Bool = false

    private func loadData(isEmptySlot: Bool = false) {
        let customColor = UIColor(red: 184.0/255.0, green: 234.0/255.0, blue: 112.0/255.0, alpha: 1.0)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)

        // Photo Action TabBar: Add/Replace, Adjust, Delete, Mute

        // First button - "Add" if empty slot, "Replace" if filled slot
        let firstButtonTitle = isEmptySlot ? "Add" : "Replace"
        if let systemImage = UIImage(systemName: "arrow.triangle.2.circlepath", withConfiguration: config) {
            let whiteImage = systemImage.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
            let selectedImage = systemImage.withTintColor(customColor, renderingMode: .alwaysOriginal)
            optionsList.append(Option(name: firstButtonTitle, image: whiteImage, selectedImage: selectedImage))
        }

        // Adjust - sliders
        if let systemImage = UIImage(systemName: "slider.horizontal.3", withConfiguration: config) {
            let whiteImage = systemImage.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
            let selectedImage = systemImage.withTintColor(customColor, renderingMode: .alwaysOriginal)
            optionsList.append(Option(name: "Adjust", image: whiteImage, selectedImage: selectedImage))
        }

        // Filter
        if let systemImage = UIImage(systemName: "camera.filters", withConfiguration: config) {
            let whiteImage = systemImage.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
            let selectedImage = systemImage.withTintColor(customColor, renderingMode: .alwaysOriginal)
            optionsList.append(Option(name: "Filter", image: whiteImage, selectedImage: selectedImage))
        }

        // Delete - trash icon
        if let systemImage = UIImage(systemName: "trash", withConfiguration: config) {
            let whiteImage = systemImage.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
            let selectedImage = systemImage.withTintColor(customColor, renderingMode: .alwaysOriginal)
            optionsList.append(Option(name: "Delete", image: whiteImage, selectedImage: selectedImage))
        }

        // Mute/Unmute - speaker icon (will be dynamically updated based on mute state)
        if let systemImage = UIImage(systemName: "speaker.wave.2", withConfiguration: config) {
            let whiteImage = systemImage.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
            let selectedImage = systemImage.withTintColor(customColor, renderingMode: .alwaysOriginal)
            optionsList.append(Option(name: "Mute", image: whiteImage, selectedImage: selectedImage))
        }
    }

    var optionsLayout: UICollectionViewFlowLayout!
    private var optionsCollectionView: UICollectionView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("--- PhotoActionViewController.swift: viewDidLoad ---")
        let user_default_color = UIColor(red: 28/255.0, green: 32/255.0, blue: 38/255.0, alpha: 1.0)
        view.backgroundColor = user_default_color
        view.layer.cornerRadius = 20

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotification(_:)),
                                               name: NSNotification.Name("resetSelectedItems"),
                                               object: nil)
        loadData(isEmptySlot: self.isEmptySlot)
        setupCollectionViews()
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
            optionsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
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
        let myNotificationName = Notification.Name("photoActionSelected")
        let params: [String: Any] = ["action": selectedOption.name]
        NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: params)
    }

    func isiPod() -> Bool {
        let device = UIDevice.current
        return device.userInterfaceIdiom == .phone && UIScreen.main.bounds.height == 568
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numofitemsforScreen = 4  // We have 4 items: Replace, Adjust, Delete, Mute
        var reminder: CGFloat = 0

        if UIDevice.current.userInterfaceIdiom == .pad {
            numofitemsforScreen = 4
            reminder = 0
        } else if isiPod() {
            reminder = 0.65
            numofitemsforScreen = 4
        } else {
            numofitemsforScreen = 4
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
