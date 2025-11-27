//
//  VideoTrimmingHostViewController.swift
//  VideoFrames
//
//  Pure UIKit video trimming interface using PryntTrimmerView library
//

import UIKit
import AVFoundation
import PryntTrimmerView

@objc class VideoTrimmingHostViewController: UIViewController {

    // MARK: - Properties (Keep @objc for MainController compatibility)

    @objc weak var photo: Photo?
    @objc var videoURL: URL?

    // Video playback
    private var asset: AVAsset?
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    // Track trimmer configuration state
    private var isTrimmerConfigured = false

    // UI Components
    private let backButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let durationLabel = UILabel()
    private let videoPreviewContainer = UIView()
    private let trimmerView = TrimmerView()
    private let startLabel = UILabel()
    private let startTimeLabel = UILabel()
    private let endLabel = UILabel()
    private let endTimeLabel = UILabel()
    private let applyButton = UIButton(type: .system)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.19, green: 0.21, blue: 0.25, alpha: 1.0)

        setupAsset()
        setupUI()
        // setupTrimmerView() - REMOVED! Now in viewDidAppear
        setupVideoPreview()
        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !isTrimmerConfigured {
            print("🎬 viewDidAppear: Setting up TrimmerView")
            setupTrimmerView()

            if !isTrimmerConfigured {
                showErrorAlert("Failed to load video thumbnails.")
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Update player layer frame
        playerLayer?.frame = videoPreviewContainer.bounds

        // Update gradient frame on apply button
        if let gradientLayer = applyButton.layer.sublayers?.first(where: { $0.name == "gradient" }) as? CAGradientLayer {
            gradientLayer.frame = applyButton.bounds
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
    }

    deinit {
        player?.pause()
        player = nil
    }

    // MARK: - Setup Methods

    private func setupAsset() {
        guard let url = videoURL else { return }
        asset = AVAsset(url: url)
    }

    private func setupUI() {
        // Back button
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        if let image = UIImage(systemName: "chevron.left", withConfiguration: config) {
            backButton.setImage(image, for: .normal)
        }
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        // Title
        titleLabel.text = "Trim Video"
        titleLabel.font = UIFont(name: "Gilroy-Bold", size: 20)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center

        // Duration label
        durationLabel.text = "Duration: 0:00"
        durationLabel.font = UIFont(name: "Gilroy-Medium", size: 16)
        durationLabel.textColor = UIColor(red: 25/255, green: 184/255, blue: 250/255, alpha: 1.0)
        durationLabel.textAlignment = .center

        // Video preview container
        videoPreviewContainer.backgroundColor = .black
        videoPreviewContainer.layer.cornerRadius = 12
        videoPreviewContainer.clipsToBounds = true

        // Time labels
        startLabel.text = "Start"
        startLabel.font = UIFont(name: "Gilroy-Medium", size: 12)
        startLabel.textColor = .gray

        startTimeLabel.text = "0:00"
        startTimeLabel.font = UIFont(name: "Gilroy-Bold", size: 16)
        startTimeLabel.textColor = UIColor(red: 25/255, green: 184/255, blue: 250/255, alpha: 1.0)

        endLabel.text = "End"
        endLabel.font = UIFont(name: "Gilroy-Medium", size: 12)
        endLabel.textColor = .gray

        endTimeLabel.text = "0:00"
        endTimeLabel.font = UIFont(name: "Gilroy-Bold", size: 16)
        endTimeLabel.textColor = UIColor(red: 25/255, green: 184/255, blue: 250/255, alpha: 1.0)

        // Apply button with gradient
        applyButton.setTitle("Apply", for: .normal)
        applyButton.titleLabel?.font = UIFont(name: "Gilroy-Bold", size: 16)
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.backgroundColor = .clear
        applyButton.layer.cornerRadius = 8
        applyButton.layer.masksToBounds = false
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)

        // Add gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 25/255, green: 184/255, blue: 250/255, alpha: 1.0).cgColor,
            UIColor(red: 0/255, green: 150/255, blue: 220/255, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 1000, height: 50)
        gradientLayer.cornerRadius = 8
        gradientLayer.name = "gradient"
        applyButton.layer.insertSublayer(gradientLayer, at: 0)

        // Shadow
        applyButton.layer.shadowColor = UIColor(red: 25/255, green: 184/255, blue: 250/255, alpha: 1.0).cgColor
        applyButton.layer.shadowOpacity = 0.3
        applyButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        applyButton.layer.shadowRadius = 8

        // Add all subviews
        [backButton, titleLabel, durationLabel, videoPreviewContainer,
         trimmerView, startLabel, startTimeLabel, endLabel, endTimeLabel, applyButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }

    private func setupTrimmerView() {
        guard let asset = asset else {
            print("❌ ERROR: No asset for trimmer")
            return
        }

        // Validate bounds before assigning asset
        guard trimmerView.bounds.width > 0 && trimmerView.bounds.height > 0 else {
            print("❌ ERROR: Invalid bounds: \(trimmerView.bounds)")
            return
        }

        print("✅ Setting up TrimmerView with bounds: \(trimmerView.bounds)")

        trimmerView.asset = asset
        trimmerView.delegate = self
        trimmerView.handleColor = .white
        trimmerView.mainColor = UIColor(red: 25/255, green: 184/255, blue: 250/255, alpha: 1.0)
        trimmerView.positionBarColor = .white

        // Note: PryntTrimmerView's startTime/endTime are read-only
        // It defaults to full video duration, which is correct behavior
        // User can then drag handles to adjust trim range

        updateTimeLabels()
        isTrimmerConfigured = true
    }

    private func setupVideoPreview() {
        guard let asset = asset else { return }

        // Create AVPlayer for preview
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)

        // Create player layer
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        playerLayer.frame = videoPreviewContainer.bounds
        videoPreviewContainer.layer.addSublayer(playerLayer)
        self.playerLayer = playerLayer

        // Mute preview
        player?.isMuted = true
    }

    private func setupConstraints() {
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        let previewHeight: CGFloat = isIPad ? 300 : 200

        NSLayoutConstraint.activate([
            // Back button (top-left)
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),

            // Title (centered with back button)
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),

            // Duration label
            durationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            durationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Video preview
            videoPreviewContainer.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 20),
            videoPreviewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            videoPreviewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            videoPreviewContainer.heightAnchor.constraint(equalToConstant: previewHeight),

            // TrimmerView
            trimmerView.topAnchor.constraint(equalTo: videoPreviewContainer.bottomAnchor, constant: 20),
            trimmerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            trimmerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            trimmerView.heightAnchor.constraint(equalToConstant: 60),

            // Time labels row
            startLabel.topAnchor.constraint(equalTo: trimmerView.bottomAnchor, constant: 16),
            startLabel.leadingAnchor.constraint(equalTo: trimmerView.leadingAnchor),

            startTimeLabel.centerYAnchor.constraint(equalTo: startLabel.centerYAnchor),
            startTimeLabel.leadingAnchor.constraint(equalTo: startLabel.trailingAnchor, constant: 8),

            endTimeLabel.centerYAnchor.constraint(equalTo: startLabel.centerYAnchor),
            endTimeLabel.trailingAnchor.constraint(equalTo: trimmerView.trailingAnchor),

            endLabel.centerYAnchor.constraint(equalTo: startLabel.centerYAnchor),
            endLabel.trailingAnchor.constraint(equalTo: endTimeLabel.leadingAnchor, constant: -8),

            // Apply button
            applyButton.topAnchor.constraint(equalTo: startLabel.bottomAnchor, constant: 24),
            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            applyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Actions

    @objc private func backButtonTapped() {
        NotificationCenter.default.post(name: NSNotification.Name("trimViewBack"), object: nil)
    }

    @objc private func applyButtonTapped() {
        // Get trim times from PryntTrimmerView
        let startTime = CMTimeGetSeconds(trimmerView.startTime ?? .zero)
        let endTime = CMTimeGetSeconds(trimmerView.endTime ?? .zero)

        // Validate minimum duration
        guard (endTime - startTime) >= 0.5 else {
            showErrorAlert("Please select at least 0.5 seconds")
            return
        }

        // Save to Photo model
        photo?.videoTrimStart = startTime
        photo?.videoTrimEnd = endTime
        photo?.applyVideoTrim(withStart: startTime, end: endTime)

        // Post notification to MainController to dismiss
        NotificationCenter.default.post(name: NSNotification.Name("videoTrimmed"), object: nil)

        // Animate button press
        UIView.animate(withDuration: 0.1, animations: {
            self.applyButton.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.applyButton.transform = .identity
            }
        }
    }

    // MARK: - Helper Methods

    private func updateTimeLabels() {
        let startTime = CMTimeGetSeconds(trimmerView.startTime ?? .zero)
        let endTime = CMTimeGetSeconds(trimmerView.endTime ?? .zero)

        startTimeLabel.text = formatTime(startTime)
        endTimeLabel.text = formatTime(endTime)

        let duration = endTime - startTime
        durationLabel.text = "Duration: \(formatTime(duration))"
    }

    private func updateVideoPreview(to time: CMTime) {
        // Seek player to specified time
        player?.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
    }

    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func showErrorAlert(_ message: String) {
        let alert = UIAlertController(title: "Invalid Trim Range",
                                     message: message,
                                     preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - TrimmerViewDelegate

extension VideoTrimmingHostViewController: TrimmerViewDelegate {
    func didChangePositionBar(_ playerTime: CMTime) {
        guard isTrimmerConfigured else { return }
        updateVideoPreview(to: playerTime)
        updateTimeLabels()
    }

    func positionBarStoppedMoving(_ playerTime: CMTime) {
        guard isTrimmerConfigured else { return }
        player?.pause()
    }
}
