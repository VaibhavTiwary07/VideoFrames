//
//  SliderViewController.swift
//  VideoFrames
//
//  Created by apple on 13/02/25.
//

import Foundation
import UIKit

class SliderViewController: UIViewController{
    
    let outerRadiusSlider = UISlider()
    let innerRadiusSlider = UISlider()
    let widthSlider = UISlider()
    let shadowSlider = UISlider()
    
    let outerRadiusLabel = UILabel()
    let innerRadiusLabel = UILabel()
    let widthLabel = UILabel()
    let shadowLabel = UILabel()
    var heightOfTitleBar : CGFloat = 60
    let screenWidth : CGFloat  = UIScreen.main.bounds.width
    // UNUSED: let screenHeight : CGFloat = UIScreen.main.bounds.height
    let RADIUS_SETTINGS_MAXIMUM: Float = 60
    let offset : CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 10 : 5
    var layoutOffset : CGFloat = UIScreen.main.bounds.height * 0.0145
    @objc var value : String?
    @objc var inner_Radius:String?
    @objc var outter_Radius :String?
    @objc var frame_Width:String?
    @objc var shadow_Value:String?
    
    var topView: ShadowContainerView = {
        let view = ShadowContainerView()
        let user_default_color =  UIColor(red:28/255.0, green:32/255.0 , blue:38/255.0, alpha:1.0)
        view.backgroundColor = user_default_color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Add a label
    private let titlLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Gilroy-Medium", size: (UIDevice.current.userInterfaceIdiom == .pad) ? 20 : 15)//UIFont.systemFont(ofSize: 15, weight: .medium)
        
        label.textColor = .white
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
        print("--- SliderViewController.swift: viewDidLoad ---")
        if((UIDevice.current.userInterfaceIdiom == .pad) )
        {
            heightOfTitleBar = 60
        }
        else if(isiPod())
        {
            heightOfTitleBar = 35
        }
        else
        {
            heightOfTitleBar = UIScreen.main.bounds.height*0.05
        }
        if(isiPod())
        {
            layoutOffset = 10;
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
        
        let user_default_color =  UIColor(red:28/255.0, green:32/255.0 , blue:38/255.0, alpha:1.0)
        view.backgroundColor = user_default_color
        
        // Add subviews
        view.addSubview(topView)
        topView.addSubview(titlLabel)
        topView.addSubview(doneButton)
        topView.addSubview(lineView)
        
        // Layout
        topView.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        titlLabel.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        doneButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        
        titlLabel.text = "Adjust"
        
        
        NSLayoutConstraint.activate([
            
            topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            topView.heightAnchor.constraint(equalToConstant: heightOfTitleBar),
            
            //titlLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 0),
            titlLabel.widthAnchor.constraint(equalToConstant: 150),
            titlLabel.heightAnchor.constraint(equalToConstant: heightOfTitleBar),
            titlLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            titlLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor,constant: 0),
            
            doneButton.widthAnchor.constraint(equalToConstant: 70),
            doneButton.heightAnchor.constraint(equalToConstant: 35),
            doneButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -offset*2),
            doneButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            
            lineView.topAnchor.constraint(equalTo: topView.bottomAnchor,constant: -1),
            lineView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1)
            
        ])
        var space:CGFloat
        if UIDevice.current.userInterfaceIdiom == .pad {
            space = UIScreen.main.bounds.height*0.03
        }else
        {
            space = 15
        }
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = space
        stackView.translatesAutoresizingMaskIntoConstraints = false
        //  stackView.backgroundColor = .green
        let OR_StackView = createSliderRow(label: outerRadiusLabel, slider: outerRadiusSlider, text: "Outer Radius")
        let IR_StackView = createSliderRow(label: innerRadiusLabel, slider: innerRadiusSlider, text: "Inner Radius")
        let FW_StackView = createSliderRow(label: widthLabel, slider: widthSlider, text: "Width")
        let SV_Stackview = createSliderRow(label: shadowLabel, slider: shadowSlider, text: "Shadow")
        
        // Configure sliders and labels in horizontal stacks
        stackView.addArrangedSubview(OR_StackView)
        stackView.addArrangedSubview(IR_StackView)
        stackView.addArrangedSubview(FW_StackView)
        stackView.addArrangedSubview(SV_Stackview)
        
        view.addSubview(stackView)
        var slider_width : CGFloat?
        
        if UIDevice.current.userInterfaceIdiom == .pad  || isiPod() {
            slider_width = screenWidth * 0.75
        }
        else
        {
            slider_width = screenWidth * 0.9
        }
        NSLayoutConstraint.activate([
//            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: topView.bottomAnchor,constant: layoutOffset),
            stackView.centerXAnchor.constraint(equalTo: topView.centerXAnchor, constant: 0),
            
            stackView.widthAnchor.constraint(equalToConstant:slider_width!),
            stackView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor,constant: -layoutOffset),
        ])
    }

    private func createSliderRow(label: UILabel, slider: UISlider, text: String) -> UIStackView {
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = (UIDevice.current.userInterfaceIdiom == .pad) ? 30 : 15
        horizontalStack.alignment = .center
        //horizontalStack.backgroundColor = .blue
        label.text = text
        // Set fixed width constraint
        var width : CGFloat
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            width = screenWidth*0.13
        }else if(isiPod())
        {
            width = screenWidth*0.25
        }else
        {
            width = screenWidth*0.20
        }
        label.widthAnchor.constraint(equalToConstant: width).isActive = true
        label.textAlignment = .right
        label.textColor = .white
        //label.backgroundColor = .systemPink
        label.font = UIFont(name: "HelveticaNeue-Light", size: (UIDevice.current.userInterfaceIdiom == .pad) ? 15.0 : 12)
        if(label.isEqual(outerRadiusLabel))
        {
            outerRadiusSlider.maximumValue = RADIUS_SETTINGS_MAXIMUM;
            outerRadiusSlider.minimumValue = 0;
            let float_OR_Value = Float(outter_Radius!) ?? 0.0
            outerRadiusSlider.value = float_OR_Value
            print("slider values ",float_OR_Value,outerRadiusSlider.value)
        }
        else if(label.isEqual(innerRadiusLabel))
        {
            
            innerRadiusSlider.maximumValue = RADIUS_SETTINGS_MAXIMUM;
            innerRadiusSlider.minimumValue = 0;
            let float_IR_Value = Float(inner_Radius!) ?? 0.0
            innerRadiusSlider.value = float_IR_Value
            print("slider values ",float_IR_Value,innerRadiusSlider.value)
        }
        else if(label.isEqual(widthLabel))
        {
           
            widthSlider.maximumValue = 30;
            widthSlider.minimumValue = 0;
            let float_FW_Value = Float(frame_Width!) ?? 0.0
            widthSlider.value = float_FW_Value
            print("slider values ",float_FW_Value,widthSlider.value)

        }
        else
        {
            shadowSlider.maximumValue = 1.0;
            shadowSlider.minimumValue = 0.0;
            let float_SV_Value = Float(shadow_Value!) ?? 0.0

            shadowSlider.value = float_SV_Value
            print("slider values ",float_SV_Value,shadowSlider.value)

        }
        slider.isContinuous = true
       // slider.backgroundColor = .brown
        slider.maximumTrackTintColor = .white
        slider.minimumTrackTintColor = .systemCyan
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
//        slider.translatesAutoresizingMaskIntoConstraints = false
//        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Set a default thumb image first
        if let thumbImage = UIImage(systemName: "circle.fill",
                                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)) {
            // Render the image with a white color
            let whiteThumbImage = thumbImage.withRenderingMode(.alwaysTemplate).withTintColor(.white)
            slider.setThumbImage(whiteThumbImage, for: .normal)
        }

        var thumbSize = 20
        if(isiPod())
        {
            thumbSize = 20
        }else
        {
            thumbSize = 30
        }
        // Now get the current image and resize it
        if let originalThumb = slider.thumbImage(for: .normal) {
            let newSize = CGSize(width: thumbSize, height: thumbSize)
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            originalThumb.draw(in: CGRect(origin: .zero, size: newSize))
            let resizedThumb = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            if let resizedThumb = resizedThumb {
                DispatchQueue.main.async {
                    slider.setThumbImage(resizedThumb, for: .normal)
                    slider.setThumbImage(resizedThumb, for: .highlighted)
                }
            }
        }
        
        slider.setNeedsDisplay()
        slider.layoutIfNeeded()
        horizontalStack.addArrangedSubview(label)
        horizontalStack.addArrangedSubview(slider)
        horizontalStack.spacing = 30
        return horizontalStack
    }

    @objc private func sliderValueChanged(_ sender: UISlider) {
        var name : String = ""
        
        if sender == outerRadiusSlider {
            name = outerRadiusLabel.text!
            //sess?.outerRadius = sender.value
        } else if sender == innerRadiusSlider {
            name = innerRadiusLabel.text!
            //sess?.innerRadius = sender.value
        } else if sender == widthSlider {
            name = widthLabel.text!
            //sess?.frameWidth = sender.value
        } else if sender == shadowSlider {
            name = shadowLabel.text!
            //sess?.shadowEffectValue = sender.value
        }
        
        let myNotificationName = Notification.Name("SliderValueChanged")
        let userInfo: [String: Any] = ["Slider": sender, "Name": name]
        NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: userInfo)
    }

    @objc func doneAction() {
        print("Done in slider is clicked")
        
        let myNotificationName = Notification.Name("BringUIBacktoNormal")
        NotificationCenter.default.post(name: myNotificationName, object: nil, userInfo: nil)
        if #available(iOS 16.0, *) {
            dismiss(animated: true, completion: nil)
        }
    }
}
