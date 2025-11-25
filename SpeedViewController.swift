//
//  SpeedViewController.swift
//  VideoFrames
//
//  Speed adjustment interface with slider (0.25x to 2.0x)
//

import Foundation
import UIKit

class SpeedViewController: UIViewController {

    let topAnchorConstant: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 20 : 15
    let viewHeight: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 90 : 70

    private var currentSpeed: Float = 1.0

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
        label.text = "Speed"
        label.font = UIFont(name: "Gilroy-Bold", size: (UIDevice.current.userInterfaceIdiom == .pad) ? 20 : 18)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var speedLabel: UILabel = {
        let label = UILabel()
        label.text = "1.0x"
        label.font = UIFont(name: "Gilroy-Bold", size: (UIDevice.current.userInterfaceIdiom == .pad) ? 32 : 28)
        label.textColor = UIColor(red: 25.0/255.0, green: 184.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var speedSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.25
        slider.maximumValue = 2.0
        slider.value = 1.0
        slider.minimumTrackTintColor = UIColor(red: 25.0/255.0, green: 184.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        slider.maximumTrackTintColor = UIColor.darkGray
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()

    private var minLabel: UILabel = {
        let label = UILabel()
        label.text = "0.25x"
        label.font = UIFont(name: "Gilroy-Medium", size: (UIDevice.current.userInterfaceIdiom == .pad) ? 14 : 12)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var maxLabel: UILabel = {
        let label = UILabel()
        label.text = "2.0x"
        label.font = UIFont(name: "Gilroy-Medium", size: (UIDevice.current.userInterfaceIdiom == .pad) ? 14 : 12)
        label.textColor = .lightGray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        print("--- SpeedViewController.swift: viewDidLoad ---")

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
        view.addSubview(containerView)

        containerView.addSubview(speedLabel)
        containerView.addSubview(speedSlider)
        containerView.addSubview(minLabel)
        containerView.addSubview(maxLabel)

        let containerHeight: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 150 : 120

        NSLayoutConstraint.activate([
            // Back button
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: topAnchorConstant),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),

            // Title label
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),

            // Container view
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            containerView.heightAnchor.constraint(equalToConstant: containerHeight),

            // Speed label
            speedLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            speedLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            // Speed slider
            speedSlider.topAnchor.constraint(equalTo: speedLabel.bottomAnchor, constant: 30),
            speedSlider.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            speedSlider.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            // Min label
            minLabel.topAnchor.constraint(equalTo: speedSlider.bottomAnchor, constant: 8),
            minLabel.leadingAnchor.constraint(equalTo: speedSlider.leadingAnchor),

            // Max label
            maxLabel.topAnchor.constraint(equalTo: speedSlider.bottomAnchor, constant: 8),
            maxLabel.trailingAnchor.constraint(equalTo: speedSlider.trailingAnchor)
        ])
    }

    private func setupActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        speedSlider.addTarget(self, action: #selector(speedSliderChanged(_:)), for: .valueChanged)
        speedSlider.addTarget(self, action: #selector(speedSliderFinished(_:)), for: [.touchUpInside, .touchUpOutside])
    }

    // MARK: - Actions
    @objc private func backButtonTapped() {
        let myNotificationName = Notification.Name("speedViewBack")
        NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: nil)
    }

    @objc private func speedSliderChanged(_ slider: UISlider) {
        currentSpeed = slider.value
        speedLabel.text = String(format: "%.2fx", currentSpeed)
    }

    @objc private func speedSliderFinished(_ slider: UISlider) {
        currentSpeed = slider.value
        speedLabel.text = String(format: "%.2fx", currentSpeed)

        // Post notification with final speed value
        let myNotificationName = Notification.Name("speedChanged")
        let params: [String: Any] = ["speed": currentSpeed]
        NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: params)

        print("Speed changed to: \(currentSpeed)x")
    }

    // MARK: - Public Methods
    @objc func setSpeed(_ speed: Float) {
        currentSpeed = speed
        speedSlider.value = speed
        speedLabel.text = String(format: "%.2fx", speed)
    }
}
