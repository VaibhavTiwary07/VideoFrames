//
//  TrimViewController.swift
//  VideoFrames
//
//  Video trimming interface with start/end sliders and apply button
//

import Foundation
import UIKit
import AVFoundation

class TrimViewController: UIViewController {

    let topAnchorConstant: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 20 : 15
    let viewHeight: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 90 : 70

    private var videoDuration: Double = 0.0
    private var startTime: Double = 0.0
    private var endTime: Double = 0.0

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

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Trim Video"
        label.font = UIFont(name: "Gilroy-Bold", size: (UIDevice.current.userInterfaceIdiom == .pad) ? 20 : 18)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var durationLabel: UILabel = {
        let label = UILabel()
        label.text = "Duration: 0:00"
        label.font = UIFont(name: "Gilroy-Medium", size: (UIDevice.current.userInterfaceIdiom == .pad) ? 16 : 14)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var startLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.font = UIFont(name: "Gilroy-Medium", size: (UIDevice.current.userInterfaceIdiom == .pad) ? 14 : 12)
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var startTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00"
        label.font = UIFont(name: "Gilroy-Bold", size: (UIDevice.current.userInterfaceIdiom == .pad) ? 16 : 14)
        label.textColor = UIColor(red: 25.0/255.0, green: 184.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var startSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = 0.0
        slider.minimumTrackTintColor = UIColor(red: 25.0/255.0, green: 184.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        slider.maximumTrackTintColor = UIColor.darkGray
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()

    private var endLabel: UILabel = {
        let label = UILabel()
        label.text = "End"
        label.font = UIFont(name: "Gilroy-Medium", size: (UIDevice.current.userInterfaceIdiom == .pad) ? 14 : 12)
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var endTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00"
        label.font = UIFont(name: "Gilroy-Bold", size: (UIDevice.current.userInterfaceIdiom == .pad) ? 16 : 14)
        label.textColor = UIColor(red: 25.0/255.0, green: 184.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var endSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = 1.0
        slider.minimumTrackTintColor = UIColor(red: 25.0/255.0, green: 184.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        slider.maximumTrackTintColor = UIColor.darkGray
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()

    private var applyButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Apply", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Gilroy-Bold", size: (UIDevice.current.userInterfaceIdiom == .pad) ? 18 : 16)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(red: 25.0/255.0, green: 184.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        btn.layer.cornerRadius = (UIDevice.current.userInterfaceIdiom == .pad) ? 12 : 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("--- TrimViewController.swift: viewDidLoad ---")

        let user_default_color = UIColor(red: 28/255.0, green: 32/255.0, blue: 38/255.0, alpha: 1.0)
        view.backgroundColor = user_default_color
        view.layer.cornerRadius = 20

        setupViews()
        setupActions()
    }

    // MARK: - Setup Methods
    private func setupViews() {
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(durationLabel)
        view.addSubview(containerView)

        containerView.addSubview(startLabel)
        containerView.addSubview(startTimeLabel)
        containerView.addSubview(startSlider)
        containerView.addSubview(endLabel)
        containerView.addSubview(endTimeLabel)
        containerView.addSubview(endSlider)
        containerView.addSubview(applyButton)

        let containerHeight: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 220 : 180
        let buttonHeight: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 50 : 44

        NSLayoutConstraint.activate([
            // Back button
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: topAnchorConstant),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),

            // Title label
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),

            // Duration label
            durationLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            durationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Container view
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 20),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            containerView.heightAnchor.constraint(equalToConstant: containerHeight),

            // Start label
            startLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            startLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),

            // Start time label
            startTimeLabel.centerYAnchor.constraint(equalTo: startLabel.centerYAnchor),
            startTimeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            // Start slider
            startSlider.topAnchor.constraint(equalTo: startLabel.bottomAnchor, constant: 8),
            startSlider.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            startSlider.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            // End label
            endLabel.topAnchor.constraint(equalTo: startSlider.bottomAnchor, constant: 20),
            endLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),

            // End time label
            endTimeLabel.centerYAnchor.constraint(equalTo: endLabel.centerYAnchor),
            endTimeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            // End slider
            endSlider.topAnchor.constraint(equalTo: endLabel.bottomAnchor, constant: 8),
            endSlider.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            endSlider.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            // Apply button
            applyButton.topAnchor.constraint(equalTo: endSlider.bottomAnchor, constant: 25),
            applyButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            applyButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5),
            applyButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }

    private func setupActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        startSlider.addTarget(self, action: #selector(startSliderChanged(_:)), for: .valueChanged)
        endSlider.addTarget(self, action: #selector(endSliderChanged(_:)), for: .valueChanged)
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
    }

    // MARK: - Actions
    @objc private func backButtonTapped() {
        let myNotificationName = Notification.Name("trimViewBack")
        NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: nil)
    }

    @objc private func startSliderChanged(_ slider: UISlider) {
        startTime = Double(slider.value) * videoDuration

        // Ensure start time doesn't exceed end time
        if startTime >= endTime && endTime > 0 {
            startTime = max(0, endTime - 0.5)
            slider.value = Float(startTime / videoDuration)
        }

        startTimeLabel.text = formatTime(startTime)
        updateDurationLabel()
    }

    @objc private func endSliderChanged(_ slider: UISlider) {
        endTime = Double(slider.value) * videoDuration

        // Ensure end time doesn't go below start time
        if endTime <= startTime {
            endTime = min(videoDuration, startTime + 0.5)
            slider.value = Float(endTime / videoDuration)
        }

        endTimeLabel.text = formatTime(endTime)
        updateDurationLabel()
    }

    @objc private func applyButtonTapped() {
        let myNotificationName = Notification.Name("videoTrimmed")
        let params: [String: Any] = [
            "startTime": startTime,
            "endTime": endTime
        ]
        NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: params)

        print("Video trimmed: \(formatTime(startTime)) to \(formatTime(endTime))")
    }

    // MARK: - Public Methods
    @objc func setVideoDuration(_ duration: Double) {
        videoDuration = duration
        startTime = 0.0
        endTime = duration

        startSlider.minimumValue = 0.0
        startSlider.maximumValue = 1.0
        startSlider.value = 0.0

        endSlider.minimumValue = 0.0
        endSlider.maximumValue = 1.0
        endSlider.value = 1.0

        startTimeLabel.text = formatTime(startTime)
        endTimeLabel.text = formatTime(endTime)
        updateDurationLabel()
    }

    @objc func setTrimRangeWithStart(_ start: Double, end: Double) {
        guard videoDuration > 0 else { return }

        startTime = start
        endTime = end

        startSlider.value = Float(startTime / videoDuration)
        endSlider.value = Float(endTime / videoDuration)

        startTimeLabel.text = formatTime(startTime)
        endTimeLabel.text = formatTime(endTime)
        updateDurationLabel()
    }

    // MARK: - Helper Methods
    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func updateDurationLabel() {
        let trimmedDuration = endTime - startTime
        durationLabel.text = "Duration: \(formatTime(trimmedDuration))"
    }
}
