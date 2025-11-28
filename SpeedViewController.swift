//
//  SpeedViewController.swift
//  VideoFrames
//
//  Professional speed adjustment interface with preset buttons and gradient Apply button
//

import UIKit
import AVFoundation

class SpeedViewController: UIViewController {

    // MARK: - Properties
    // Video preview support
    @objc weak var photo: Photo?
    @objc var videoURL: URL?

    private var asset: AVAsset?
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var isVideoPreviewConfigured = false

    private let videoPreviewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let speedDisplayLabel = UILabel()
    private let speedSlider = UISlider()
    private let minLabel = UILabel()
    private let maxLabel = UILabel()
    private let applyButton = UIButton(type: .system)
    private let resetButton = UIButton(type: .system)
    private let backButton = UIButton(type: .system)

    // Preset buttons
    private let presetButtonsStack = UIStackView()
    private let presets: [Float] = [0.25, 0.5, 1.0, 1.5, 2.0]
    private var presetButtons: [UIButton] = []

    private var currentSpeed: Float = 1.0
    private var initialSpeed: Float = 1.0

    // Playback controls
    private let playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium)
        button.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        button.layer.cornerRadius = 35
        button.clipsToBounds = true
        return button
    }()

    private let scrubberSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.minimumTrackTintColor = UIColor(red: 184/255, green: 234/255, blue: 112/255, alpha: 1.0)
        slider.maximumTrackTintColor = UIColor.white.withAlphaComponent(0.3)
        return slider
    }()

    private let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Gilroy-Medium", size: 12)
        label.textColor = .white.withAlphaComponent(0.7)
        label.text = "0:00"
        return label
    }()

    private let totalTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Gilroy-Medium", size: 12)
        label.textColor = .white.withAlphaComponent(0.7)
        label.textAlignment = .right
        label.text = "0:00"
        return label
    }()

    private var timeObserver: Any?
    private var isScrubbing = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        setupAsset()
        setupViews()
        setupConstraints()
        setupActions()
        // setupVideoPreview() - REMOVED! Now in viewDidAppear
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !isVideoPreviewConfigured {
            print("🎬 viewDidAppear: Setting up video preview")
            print("   Container bounds: \(videoPreviewContainer.bounds)")
            setupVideoPreview()
            isVideoPreviewConfigured = true
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = videoPreviewContainer.bounds

        if let gradientLayer = applyButton.layer.sublayers?.first(where: { $0.name == "gradient" }) as? CAGradientLayer {
            gradientLayer.frame = applyButton.bounds
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
    }

    deinit {
        // Remove time observer
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
        player?.pause()
        player = nil
    }

    // MARK: - Setup

    private func setupAsset() {
        guard let url = videoURL else { return }
        asset = AVAsset(url: url)
    }

    private func setupVideoPreview() {
        guard let asset = asset else {
            print("❌ No asset for video preview")
            return
        }

        guard videoPreviewContainer.bounds.width > 0 else {
            print("❌ Invalid container bounds: \(videoPreviewContainer.bounds)")
            return
        }

        print("✅ Setting up video preview with bounds: \(videoPreviewContainer.bounds)")

        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)

        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        playerLayer.frame = videoPreviewContainer.bounds
        videoPreviewContainer.layer.addSublayer(playerLayer)
        self.playerLayer = playerLayer

        player?.isMuted = true

        // Setup time observer for scrubber
        let interval = CMTime(seconds: 0.1, preferredTimescale: 600)
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] _ in
            self?.updatePlaybackTimeLabels()
        }

        // Initialize total time label
        let totalDuration = CMTimeGetSeconds(asset.duration)
        totalTimeLabel.text = formatPlaybackTime(totalDuration)

        // Loop video - play at the current selected speed!
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.player?.seek(to: .zero)
            self.player?.rate = self.currentSpeed
        }

        // Start playing at initial speed (1.0x)
        player?.rate = currentSpeed
    }

    private func setupViews() {
        // Container
        containerView.backgroundColor = .black
        view.addSubview(containerView)

        // Back Button
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        if let image = UIImage(systemName: "chevron.left", withConfiguration: config) {
            backButton.setImage(image, for: .normal)
        }
        backButton.tintColor = .white
        containerView.addSubview(backButton)

        // Title
        titleLabel.text = "Speed"
        titleLabel.font = UIFont(name: "Gilroy-Bold", size: 20)
        titleLabel.textColor = .white
        containerView.addSubview(titleLabel)

        // Video Preview Container
        containerView.addSubview(videoPreviewContainer)

        // Playback controls
        videoPreviewContainer.addSubview(playPauseButton)
        containerView.addSubview(scrubberSlider)
        containerView.addSubview(currentTimeLabel)
        containerView.addSubview(totalTimeLabel)

        // Speed Display
        speedDisplayLabel.text = "1.0x"
        speedDisplayLabel.font = UIFont(name: "Gilroy-Bold", size: 32)
        speedDisplayLabel.textColor = UIColor(red: 184/255, green: 234/255, blue: 112/255, alpha: 1.0)
        speedDisplayLabel.textAlignment = .center
        containerView.addSubview(speedDisplayLabel)

        // Preset Buttons
        presetButtonsStack.axis = .horizontal
        presetButtonsStack.distribution = .fillEqually
        presetButtonsStack.spacing = 8
        containerView.addSubview(presetButtonsStack)

        for preset in presets {
            let button = createPresetButton(speed: preset)
            presetButtons.append(button)
            presetButtonsStack.addArrangedSubview(button)
        }

        // Slider
        speedSlider.minimumValue = 0.25
        speedSlider.maximumValue = 2.0
        speedSlider.value = 1.0
        speedSlider.minimumTrackTintColor = UIColor(red: 184/255, green: 234/255, blue: 112/255, alpha: 1.0)
        speedSlider.maximumTrackTintColor = UIColor.white.withAlphaComponent(0.3)
        speedSlider.setThumbImage(createThumbImage(), for: .normal)
        containerView.addSubview(speedSlider)

        // Min/Max Labels
        minLabel.text = "0.25x"
        minLabel.font = UIFont(name: "Gilroy-Medium", size: 12)
        minLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        containerView.addSubview(minLabel)

        maxLabel.text = "2.0x"
        maxLabel.font = UIFont(name: "Gilroy-Medium", size: 12)
        maxLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        maxLabel.textAlignment = .right
        containerView.addSubview(maxLabel)

        // Apply Button (Gradient)
        applyButton.setTitle("Apply", for: .normal)
        applyButton.titleLabel?.font = UIFont(name: "Gilroy-Bold", size: 16)
        applyButton.setTitleColor(.black, for: .normal)
        applyButton.backgroundColor = .clear
        applyButton.layer.cornerRadius = 8
        applyButton.layer.masksToBounds = false

        // Add gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 184/255, green: 234/255, blue: 112/255, alpha: 1.0).cgColor,
            UIColor(red: 20/255, green: 249/255, blue: 245/255, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 1000, height: 50)
        gradientLayer.cornerRadius = 8
        gradientLayer.name = "gradient"
        applyButton.layer.insertSublayer(gradientLayer, at: 0)

        // Shadow
        applyButton.layer.shadowColor = UIColor(red: 184/255, green: 234/255, blue: 112/255, alpha: 1.0).cgColor
        applyButton.layer.shadowOpacity = 0.3
        applyButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        applyButton.layer.shadowRadius = 8

        containerView.addSubview(applyButton)

        // Reset Button
        resetButton.setTitle("Reset", for: .normal)
        resetButton.titleLabel?.font = UIFont(name: "Gilroy-Medium", size: 14)
        resetButton.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
        containerView.addSubview(resetButton)
    }

    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        videoPreviewContainer.translatesAutoresizingMaskIntoConstraints = false
        speedDisplayLabel.translatesAutoresizingMaskIntoConstraints = false
        presetButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        speedSlider.translatesAutoresizingMaskIntoConstraints = false
        minLabel.translatesAutoresizingMaskIntoConstraints = false
        maxLabel.translatesAutoresizingMaskIntoConstraints = false
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false

        // Playback controls
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        scrubberSlider.translatesAutoresizingMaskIntoConstraints = false
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        totalTimeLabel.translatesAutoresizingMaskIntoConstraints = false

        let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        let previewHeight: CGFloat = isIPad ? 280 : 160

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            backButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            backButton.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            // Video preview (NEW - between title and speed display)
            videoPreviewContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            videoPreviewContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            videoPreviewContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            videoPreviewContainer.heightAnchor.constraint(equalToConstant: previewHeight),

            // Play/Pause button (centered in preview)
            playPauseButton.centerXAnchor.constraint(equalTo: videoPreviewContainer.centerXAnchor),
            playPauseButton.centerYAnchor.constraint(equalTo: videoPreviewContainer.centerYAnchor),
            playPauseButton.widthAnchor.constraint(equalToConstant: 70),
            playPauseButton.heightAnchor.constraint(equalToConstant: 70),

            // Scrubber slider (below preview)
            scrubberSlider.topAnchor.constraint(equalTo: videoPreviewContainer.bottomAnchor, constant: 8),
            scrubberSlider.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 60),
            scrubberSlider.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -60),
            scrubberSlider.heightAnchor.constraint(equalToConstant: 20),

            // Time labels
            currentTimeLabel.centerYAnchor.constraint(equalTo: scrubberSlider.centerYAnchor),
            currentTimeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            currentTimeLabel.trailingAnchor.constraint(equalTo: scrubberSlider.leadingAnchor, constant: -8),

            totalTimeLabel.centerYAnchor.constraint(equalTo: scrubberSlider.centerYAnchor),
            totalTimeLabel.leadingAnchor.constraint(equalTo: scrubberSlider.trailingAnchor, constant: 8),
            totalTimeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            // Speed display (moved below scrubber)
            speedDisplayLabel.topAnchor.constraint(equalTo: scrubberSlider.bottomAnchor, constant: 12),
            speedDisplayLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            presetButtonsStack.topAnchor.constraint(equalTo: speedDisplayLabel.bottomAnchor, constant: 16),
            presetButtonsStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            presetButtonsStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            presetButtonsStack.heightAnchor.constraint(equalToConstant: 40),

            speedSlider.topAnchor.constraint(equalTo: presetButtonsStack.bottomAnchor, constant: 20),
            speedSlider.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            speedSlider.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            speedSlider.heightAnchor.constraint(equalToConstant: 30),

            minLabel.topAnchor.constraint(equalTo: speedSlider.bottomAnchor, constant: 8),
            minLabel.leadingAnchor.constraint(equalTo: speedSlider.leadingAnchor),

            maxLabel.topAnchor.constraint(equalTo: speedSlider.bottomAnchor, constant: 8),
            maxLabel.trailingAnchor.constraint(equalTo: speedSlider.trailingAnchor),

            applyButton.bottomAnchor.constraint(equalTo: resetButton.topAnchor, constant: -16),
            applyButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            applyButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            applyButton.heightAnchor.constraint(equalToConstant: 50),

            resetButton.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            resetButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }

    private func setupActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        speedSlider.addTarget(self, action: #selector(speedSliderChanged), for: .valueChanged)
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)

        // Playback controls
        playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        scrubberSlider.addTarget(self, action: #selector(scrubberTouchDown), for: .touchDown)
        scrubberSlider.addTarget(self, action: #selector(scrubberValueChanged), for: .valueChanged)
        scrubberSlider.addTarget(self, action: #selector(scrubberTouchUp), for: [.touchUpInside, .touchUpOutside])
    }

    // MARK: - Helper Methods

    private func createPresetButton(speed: Float) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(String(format: "%.2fx", speed), for: .normal)
        button.titleLabel?.font = UIFont(name: "Gilroy-Bold", size: 14)
        button.setTitleColor(.white.withAlphaComponent(0.7), for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        button.layer.cornerRadius = 6
        button.tag = Int(speed * 100)
        button.addTarget(self, action: #selector(presetButtonTapped(_:)), for: .touchUpInside)
        return button
    }

    private func createThumbImage() -> UIImage {
        let size = CGSize(width: 24, height: 24)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)

        let circle = UIBezierPath(ovalIn: CGRect(origin: .zero, size: size))
        UIColor.white.setFill()
        circle.fill()

        UIColor(red: 184/255, green: 234/255, blue: 112/255, alpha: 1.0).setStroke()
        circle.lineWidth = 2
        circle.stroke()

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image ?? UIImage()
    }

    private func updatePresetButtonsSelection() {
        for button in presetButtons {
            let buttonSpeed = Float(button.tag) / 100.0
            let isSelected = abs(buttonSpeed - currentSpeed) < 0.01

            button.backgroundColor = isSelected
                ? UIColor(red: 184/255, green: 234/255, blue: 112/255, alpha: 1.0)
                : UIColor.white.withAlphaComponent(0.1)

            button.setTitleColor(isSelected ? .white : .white.withAlphaComponent(0.7), for: .normal)
        }
    }

    // MARK: - Actions

    @objc private func backButtonTapped() {
        NotificationCenter.default.post(name: NSNotification.Name("speedViewBack"), object: nil)
    }

    @objc private func speedSliderChanged(_ sender: UISlider) {
        currentSpeed = sender.value
        speedDisplayLabel.text = String(format: "%.2fx", currentSpeed)
        updatePresetButtonsSelection()

        // CRITICAL: Actually change the playback speed!
        player?.rate = currentSpeed
    }

    @objc private func presetButtonTapped(_ sender: UIButton) {
        let speed = Float(sender.tag) / 100.0
        currentSpeed = speed
        speedSlider.value = speed
        speedDisplayLabel.text = String(format: "%.2fx", speed)
        updatePresetButtonsSelection()

        // CRITICAL: Actually change the playback speed!
        player?.rate = speed

        // Animate button press
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                sender.transform = .identity
            }
        }
    }

    @objc private func applyButtonTapped() {
        NotificationCenter.default.post(
            name: NSNotification.Name("speedChanged"),
            object: nil,
            userInfo: ["speed": currentSpeed]
        )

        // Animate button press
        UIView.animate(withDuration: 0.1, animations: {
            self.applyButton.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.applyButton.transform = .identity
            }
        }
    }

    @objc private func resetButtonTapped() {
        currentSpeed = 1.0
        speedSlider.value = 1.0
        speedDisplayLabel.text = "1.0x"
        updatePresetButtonsSelection()
    }

    // MARK: - Playback Control Actions

    @objc private func playPauseButtonTapped() {
        guard let player = player else { return }

        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium)

        if player.timeControlStatus == .playing {
            player.pause()
            playPauseButton.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: config), for: .normal)
        } else {
            // Play at the current selected speed!
            player.rate = currentSpeed
            playPauseButton.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: config), for: .normal)
        }
    }

    @objc private func scrubberTouchDown() {
        isScrubbing = true
        player?.pause()
    }

    @objc private func scrubberValueChanged(_ sender: UISlider) {
        guard let asset = asset else { return }

        let duration = CMTimeGetSeconds(asset.duration)
        let seekTime = CMTime(seconds: Double(sender.value) * duration, preferredTimescale: 600)

        player?.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero)
        updatePlaybackTimeLabels()
    }

    @objc private func scrubberTouchUp() {
        isScrubbing = false
        // Resume playing at the current selected speed!
        player?.rate = currentSpeed

        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium)
        playPauseButton.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: config), for: .normal)
    }

    private func updatePlaybackTimeLabels() {
        guard let player = player, let asset = asset else { return }

        let currentTime = CMTimeGetSeconds(player.currentTime())
        let totalDuration = CMTimeGetSeconds(asset.duration)

        currentTimeLabel.text = formatPlaybackTime(currentTime)
        totalTimeLabel.text = formatPlaybackTime(totalDuration)

        if !isScrubbing && totalDuration > 0 {
            scrubberSlider.value = Float(currentTime / totalDuration)
        }
    }

    private func formatPlaybackTime(_ time: Double) -> String {
        guard time.isFinite && time >= 0 else { return "0:00" }
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    // MARK: - Public Methods

    @objc func setSpeed(_ speed: Float) {
        currentSpeed = speed
        initialSpeed = speed
        speedSlider.value = speed
        speedDisplayLabel.text = String(format: "%.2fx", speed)
        updatePresetButtonsSelection()
    }
}
