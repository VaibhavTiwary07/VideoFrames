//
//  FrameSelectionViewControllerNew.swift
//  VideoFrames
//
//  Modern frame selection view controller using MVVM
//

import UIKit

// MARK: - Frame Selection View Controller
final class FrameSelectionViewControllerNew: UIViewController {

    // MARK: - Properties
    private let viewModel: FrameSelectionViewModel
    private var collectionView: UICollectionView!

    weak var delegate: FrameSelectionDelegate? {
        didSet {
            viewModel.delegate = delegate
        }
    }

    // Coordinator for navigation
    weak var coordinator: FrameSelectionCoordinator?

    // MARK: - UI Constants
    private let numberOfColumns: CGFloat = 3
    private let cellSpacing: CGFloat = 10
    private let sectionInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)

    // MARK: - Initialization
    init(viewModel: FrameSelectionViewModel = FrameSelectionViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = FrameSelectionViewModel()
        super.init(coder: coder)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        bindViewModel()
        viewModel.loadFrames()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .black

        setupCollectionView()
    }

    private func setupNavigationBar() {
        title = "Select Frame"

        // Navigation bar styling
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .black
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.white,
                .font: UIFont.boldSystemFont(ofSize: 17)
            ]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        navigationController?.navigationBar.tintColor = .white

        // Done button with gradient
        let doneButton = createGradientDoneButton()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)

        // Back button
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "back_arrow"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FrameCellNew.self, forCellWithReuseIdentifier: FrameCellNew.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func createGradientDoneButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.frame = CGRect(x: 0, y: 0, width: 70, height: 35)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)

        // Gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = button.bounds
        gradientLayer.colors = [
            UIColor(red: 188/255, green: 234/255, blue: 109/255, alpha: 1).cgColor,
            UIColor(red: 20/255, green: 249/255, blue: 245/255, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = 5
        button.layer.insertSublayer(gradientLayer, at: 0)

        return button
    }

    // MARK: - ViewModel Binding
    private func bindViewModel() {
        viewModel.onFramesLoaded = { [weak self] _ in
            self?.collectionView.reloadData()
        }

        viewModel.onSelectionChanged = { [weak self] previousIndex, newIndex in
            var indexPathsToReload: [IndexPath] = []

            if let prev = previousIndex {
                indexPathsToReload.append(IndexPath(item: prev, section: 0))
            }
            if let new = newIndex {
                indexPathsToReload.append(IndexPath(item: new, section: 0))
            }

            self?.collectionView.reloadItems(at: indexPathsToReload)
        }

        viewModel.onError = { [weak self] error in
            self?.showError(error)
        }
    }

    // MARK: - Actions
    @objc private func doneButtonTapped() {
        if let frame = viewModel.selectedFrame {
            // Use coordinator for navigation if available
            if let coordinator = coordinator {
                coordinator.didSelectFrame(frame)
            } else {
                // Fallback to delegate pattern
                delegate?.didSelectFrame(frame, at: viewModel.selectedIndex ?? 0)
                navigationController?.popViewController(animated: true)
            }
        }
    }

    @objc private func backButtonTapped() {
        viewModel.cancel()
        // Use coordinator for navigation if available
        if let coordinator = coordinator {
            coordinator.didCancel()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    // MARK: - Helper Methods
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension FrameSelectionViewControllerNew: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.frameCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FrameCellNew.identifier,
            for: indexPath
        ) as! FrameCellNew

        if let cellData = viewModel.cellData(at: indexPath.item) {
            cell.configure(with: cellData)
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension FrameSelectionViewControllerNew: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectFrame(at: indexPath.item)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FrameSelectionViewControllerNew: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width - sectionInsets.left - sectionInsets.right
        let cellWidth = (availableWidth - (cellSpacing * (numberOfColumns - 1))) / numberOfColumns
        let maxWidth: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 120 : 100
        let finalWidth = min(cellWidth, maxWidth)
        return CGSize(width: finalWidth, height: finalWidth)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}

// MARK: - Frame Cell New
final class FrameCellNew: UICollectionViewCell {

    static let identifier = "FrameCellNew"

    // MARK: - UI Elements
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 4
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let lockIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "ProBadge")
        iv.contentMode = .scaleAspectFit
        iv.isHidden = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.layer.cornerRadius = 4
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = UIColor.lightGray.cgColor

        contentView.addSubview(imageView)
        contentView.addSubview(lockIcon)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),

            lockIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            lockIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            lockIcon.widthAnchor.constraint(equalToConstant: 20),
            lockIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    // MARK: - Configuration
    func configure(with data: FrameCellData) {
        imageView.image = UIImage(named: data.thumbnailName)
        lockIcon.isHidden = !data.isLocked

        if data.isSelected {
            contentView.layer.borderColor = UIColor(red: 184/255, green: 234/255, blue: 112/255, alpha: 1).cgColor
            transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        } else {
            contentView.layer.borderColor = UIColor.lightGray.cgColor
            transform = .identity
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        lockIcon.isHidden = true
        transform = .identity
        contentView.layer.borderColor = UIColor.lightGray.cgColor
    }
}
