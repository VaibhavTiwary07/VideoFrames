//
//  VolumeViewController.swift
//  VideoFrames
//
//  Volume control for selected photo slot's video
//

import Foundation
import UIKit

class VolumeViewController: UIViewController {

    let volumeSlider = UISlider()
    let volumeLabel = UILabel()
    let volumeValueLabel = UILabel()
    var heightOfTitleBar: CGFloat = 60
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let offset: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 10 : 5
    var layoutOffset: CGFloat = UIScreen.main.bounds.height * 0.0145

    // Current volume value (0.0 to 1.0)
    @objc var currentVolume: Float = 1.0

    var topView: UIView = {
        let view = UIView()
        let user_default_color = UIColor(red: 28/255.0, green: 32/255.0, blue: 38/255.0, alpha: 1.0)
        view.backgroundColor = user_default_color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Gilroy-Medium", size: (UIDevice.current.userInterfaceIdiom == .pad) ? 20 : 15)
        label.textColor = .white
        label.text = "Volume"
        return label
    }()

    var doneButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Done", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.layer.cornerRadius = 5.0
        btn.clipsToBounds = true
        btn.isUserInteractionEnabled = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private func applyGradientToDoneButton() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = doneButton.bounds
        let greenColor = UIColor(red: 188/255.0, green: 234/255.0, blue: 109/255.0, alpha: 1.0)
        let cyanColor = UIColor(red: 20/255.0, green: 249/255.0, blue: 245/255.0, alpha: 1.0)
        gradientLayer.colors = [greenColor.cgColor, cyanColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = 5.0
        doneButton.layer.insertSublayer(gradientLayer, at: 0)
    }

    var lineView: UIView = {
        let view = UIView()
        let color = UIColor(red: 48.0/255.0, green: 51.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        view.backgroundColor = color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("--- VolumeViewController.swift: viewDidLoad ---")

        if UIDevice.current.userInterfaceIdiom == .pad {
            heightOfTitleBar = 60
        } else if isiPod() {
            heightOfTitleBar = 35
        } else {
            heightOfTitleBar = UIScreen.main.bounds.height * 0.05
        }

        if isiPod() {
            layoutOffset = 10
        }

        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if doneButton.layer.sublayers?.first(where: { $0 is CAGradientLayer }) == nil {
            applyGradientToDoneButton()
        }
    }

    func isiPod() -> Bool {
        let device = UIDevice.current
        return device.userInterfaceIdiom == .phone && UIScreen.main.bounds.height == 568
    }

    private func setupUI() {
        let user_default_color = UIColor(red: 28/255.0, green: 32/255.0, blue: 38/255.0, alpha: 1.0)
        view.backgroundColor = user_default_color

        // Add subviews
        view.addSubview(topView)
        topView.addSubview(titleLabel)
        topView.addSubview(doneButton)
        topView.addSubview(lineView)

        // Layout
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        doneButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)

        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            topView.heightAnchor.constraint(equalToConstant: heightOfTitleBar),

            titleLabel.widthAnchor.constraint(equalToConstant: 150),
            titleLabel.heightAnchor.constraint(equalToConstant: heightOfTitleBar),
            titleLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: 0),

            doneButton.widthAnchor.constraint(equalToConstant: 70),
            doneButton.heightAnchor.constraint(equalToConstant: 35),
            doneButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -offset * 2),
            doneButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),

            lineView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: -1),
            lineView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])

        // Setup volume slider
        setupVolumeSlider()
    }

    private func setupVolumeSlider() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        // Volume label
        volumeLabel.text = "Video Volume"
        volumeLabel.textColor = .white
        volumeLabel.font = UIFont(name: "HelveticaNeue-Light", size: (UIDevice.current.userInterfaceIdiom == .pad) ? 15.0 : 12)
        volumeLabel.textAlignment = .center
        volumeLabel.translatesAutoresizingMaskIntoConstraints = false

        // Volume value label (shows percentage)
        volumeValueLabel.text = "\(Int(currentVolume * 100))%"
        volumeValueLabel.textColor = .systemCyan
        volumeValueLabel.font = UIFont(name: "HelveticaNeue-Medium", size: (UIDevice.current.userInterfaceIdiom == .pad) ? 18.0 : 14)
        volumeValueLabel.textAlignment = .center
        volumeValueLabel.translatesAutoresizingMaskIntoConstraints = false

        // Configure slider
        volumeSlider.minimumValue = 0.0
        volumeSlider.maximumValue = 1.0
        volumeSlider.value = currentVolume
        volumeSlider.isContinuous = true
        volumeSlider.maximumTrackTintColor = .white
        volumeSlider.minimumTrackTintColor = .systemCyan
        volumeSlider.translatesAutoresizingMaskIntoConstraints = false
        volumeSlider.addTarget(self, action: #selector(volumeSliderChanged(_:)), for: .valueChanged)

        // Set thumb image
        if let thumbImage = UIImage(systemName: "circle.fill",
                                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)) {
            let whiteThumbImage = thumbImage.withRenderingMode(.alwaysTemplate).withTintColor(.white)
            volumeSlider.setThumbImage(whiteThumbImage, for: .normal)
        }

        // Resize thumb
        let thumbSize = isiPod() ? 20 : 30
        if let originalThumb = volumeSlider.thumbImage(for: .normal) {
            let newSize = CGSize(width: thumbSize, height: thumbSize)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            originalThumb.draw(in: CGRect(origin: .zero, size: newSize))
            let resizedThumb = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            if let resizedThumb = resizedThumb {
                volumeSlider.setThumbImage(resizedThumb, for: .normal)
                volumeSlider.setThumbImage(resizedThumb, for: .highlighted)
            }
        }

        containerView.addSubview(volumeLabel)
        containerView.addSubview(volumeSlider)
        containerView.addSubview(volumeValueLabel)

        var sliderWidth: CGFloat
        if UIDevice.current.userInterfaceIdiom == .pad || isiPod() {
            sliderWidth = screenWidth * 0.75
        } else {
            sliderWidth = screenWidth * 0.9
        }

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: layoutOffset * 2),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: sliderWidth),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -layoutOffset),

            volumeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            volumeLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            volumeSlider.topAnchor.constraint(equalTo: volumeLabel.bottomAnchor, constant: 20),
            volumeSlider.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            volumeSlider.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            volumeValueLabel.topAnchor.constraint(equalTo: volumeSlider.bottomAnchor, constant: 10),
            volumeValueLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }

    @objc private func volumeSliderChanged(_ sender: UISlider) {
        currentVolume = sender.value
        volumeValueLabel.text = "\(Int(currentVolume * 100))%"

        // Post notification for volume change
        let myNotificationName = Notification.Name("VolumeValueChanged")
        let userInfo: [String: Any] = ["Volume": sender.value]
        NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: userInfo)
    }

    @objc func doneAction() {
        print("Done in volume is clicked")

        let myNotificationName = Notification.Name("BringUIBacktoNormal")
        NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: nil)
        if #available(iOS 16.0, *) {
            dismiss(animated: true, completion: nil)
        }
    }
}
