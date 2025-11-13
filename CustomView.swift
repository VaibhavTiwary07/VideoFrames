//
//  CustomView.swift
//  VideoFrames
//
//  Created by apple on 21/02/25.
//
@objc protocol CustomViewDelegate: AnyObject {
    func addTextViewToParent(textView: UITextView)
}

import Foundation
import UIKit

@objc class CustomView: UIView,UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIColorPickerViewControllerDelegate{
    
    @objc weak var delegate: CustomViewDelegate?
    //private let label: UILabel
    private var textBox = UITextView()
    var trashBinView: UIImageView!
    private let maxWidth: CGFloat = 300 // Adjust based on your layout
    private let maxHeight: CGFloat = 400
    private var initialTextViewSize: CGSize = .zero
    private let fontNames = UIFont.familyNames.shuffled()
    private let alignments: [NSTextAlignment] = [.left, .center, .right, .justified]
    private var selectedAlignment: NSTextAlignment = .center
    var alignmentIndex = 0
    var isCustomFrameEnabled = false
    
    let fontSizeSlider = UISlider()
    
    let trackImgV: UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "slidertrackImage")
        imgV.contentMode = .scaleAspectFill
        imgV.translatesAutoresizingMaskIntoConstraints = false
        return imgV
    }()
    
    let fontsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10 // Spacing between items horizontally
        layout.minimumLineSpacing = 10 // Spacing between items vertically
        layout.scrollDirection = .vertical // The direction in which items will scroll
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(FontCell.self, forCellWithReuseIdentifier: "FontCell")
        cv.isUserInteractionEnabled = true
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let alignmentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(AlignmentCell.self, forCellWithReuseIdentifier: "AlignmentCell")
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let ellipsisOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let toolbar = UIToolbar()
    var keyboardHeight: CGFloat = 216 // Default height for iPhones (will update dynamically)
    
    var isCollectionViewVisible = false // Flag to track visibility
    
    var titleLable: UILabel = {
        let lbl = UILabel()
        lbl.text = "Alignment:"
        lbl.textColor = .lightGray
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var titleLableColor: UILabel = {
        let lbl = UILabel()
        lbl.text = "Text Overlay Color:"
        lbl.textColor = .lightGray
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Custom initializer for Objective-C
    @objc init(frame: CGRect, text: String, backgroundColor: UIColor) {
       // self.label = UILabel()
        super.init(frame: frame) // Call UIView’s designated initializer
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardd))
        addGestureRecognizer(tapGesture)
        
        self.backgroundColor = backgroundColor
        
//        label.text = text
//        label.textAlignment = .center
//        label.textColor = .white
//        label.frame = bounds
//        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        
//        addSubview(label)
        fontsCollectionView.delegate = self
        fontsCollectionView.dataSource = self
        
        alignmentCollectionView.delegate = self
        alignmentCollectionView.dataSource = self
        
        // overlayView.isHidden = true
        fontsCollectionView.isHidden = true
        
    
        setUpConstraints()
        setupSlider()
        toolbar.items = createToolbarItems()
        
        toolbar.isHidden = true
        ellipsisOverlay.isHidden = true
        
        // Add keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        setupTrashBin()
        addtext()
        fontSizeSlider.isHidden = true
    }
    
    @objc func dismissKeyboardd() {
        print("dismiss keyboard")
        endEditing(true)
        toolbar.isHidden = true
        fontSizeSlider.isHidden = true
        self.isHidden = true
        ellipsisOverlay.isHidden = true
        fontsCollectionView.isHidden = true
    }
    
    func setUpConstraints() {
        addSubview(fontsCollectionView)
        fontsCollectionView.backgroundColor = .black
        addSubview(toolbar)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.layer.cornerRadius = 12
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo:trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -312),
            toolbar.heightAnchor.constraint(equalToConstant: 44) // Standard toolbar height
        ])
        NSLayoutConstraint.activate([
            fontsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            fontsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            fontsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            fontsCollectionView.topAnchor.constraint(equalTo:  toolbar.bottomAnchor),
        ])
    
        
        
        addSubview(ellipsisOverlay)
        
        
        NSLayoutConstraint.activate([
            ellipsisOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            ellipsisOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            ellipsisOverlay.bottomAnchor.constraint(equalTo: bottomAnchor),
            ellipsisOverlay.topAnchor.constraint(equalTo:  toolbar.bottomAnchor),
        ])
        
        ellipsisOverlay.addSubview(titleLable)
        ellipsisOverlay.addSubview(titleLableColor)
        ellipsisOverlay.addSubview(alignmentCollectionView)
        
        NSLayoutConstraint.activate([
            
            titleLable.leadingAnchor.constraint(equalTo: ellipsisOverlay.safeAreaLayoutGuide.leadingAnchor
                                                , constant: 15),
            titleLable.topAnchor.constraint(equalTo: ellipsisOverlay.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            alignmentCollectionView.leadingAnchor.constraint(equalTo: ellipsisOverlay.safeAreaLayoutGuide.leadingAnchor
                                                             , constant: 15),
            alignmentCollectionView.trailingAnchor.constraint(equalTo: ellipsisOverlay.safeAreaLayoutGuide.trailingAnchor
                                                              , constant: -15),
            alignmentCollectionView.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 7),
            
            alignmentCollectionView.heightAnchor.constraint(equalToConstant: 100),
            
            titleLableColor.topAnchor.constraint(equalTo: alignmentCollectionView.bottomAnchor),
            titleLableColor.leadingAnchor.constraint(equalTo: alignmentCollectionView.leadingAnchor)
        ])
    }
    
    func setupSlider() {
        fontSizeSlider.translatesAutoresizingMaskIntoConstraints = false
        
        // Rotate the slider vertically (-90 degrees)
        fontSizeSlider.transform = CGAffineTransform(rotationAngle: -.pi / 2)

        // Slider range
        fontSizeSlider.minimumValue = 10
        fontSizeSlider.maximumValue = 50
        fontSizeSlider.value = 16

        // Set custom thumb image
        if let thumbImage = UIImage(systemName: "circle.fill",
                                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)) {
            fontSizeSlider.setThumbImage(thumbImage, for: .normal)
        }

        fontSizeSlider.tintColor = .white // Track color

        // Add target for value change
        fontSizeSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)

        addSubview(fontSizeSlider)

        // 🔹 Auto Layout Constraints
        NSLayoutConstraint.activate([
            fontSizeSlider.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50),
            fontSizeSlider.leadingAnchor.constraint(equalTo:leadingAnchor, constant: -100),
            fontSizeSlider.heightAnchor.constraint(equalToConstant: 40), // Adjusted for rotation
            fontSizeSlider.widthAnchor.constraint(equalToConstant: 230) // Ensures full vertical length
        ])
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        let fontSize = CGFloat(sender.value)
        
        // Update font size without changing attributes unnecessarily
        if textBox.font?.pointSize != fontSize {
            textBox.font = textBox.font?.withSize(fontSize)
        }

        // Calculate new text size
        let maxWidth = frame.width - 40 // Keep some padding
        let maxHeight = frame.height - 200 // Prevent excessive height

        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: textBox.font!
        ]

        let textSize = (textBox.text as NSString).boundingRect(
            with: CGSize(width: maxWidth, height: maxHeight),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: textAttributes,
            context: nil
        ).size

        let newWidth = min(textSize.width + 25, maxWidth)
        let newHeight = min(textSize.height + 30, maxHeight)

        // Prevent unnecessary updates (only update frame if size changes)
        if textBox.frame.size.width != newWidth || textBox.frame.size.height != newHeight {
            UIView.animate(withDuration: 0.1, animations: {
                self.textBox.frame.size = CGSize(width: newWidth, height: newHeight)
            })
        }
    }


    
    func addtext()
    {
        UserDefaults.standard.setValue(true, forKey: "fromText")
        addTextBox()
        toolbar.isHidden = false
        textBox.becomeFirstResponder()
        print("Text Tapped")
    }
    
    private func addTextBox() {
        // This line might be used to track that text has been added
        UserDefaults.standard.setValue(true, forKey: "fromText")
        fontSizeSlider.isHidden = false
        textBox.text = "Tap to edit"
        textBox.font = UIFont.systemFont(ofSize: 26) // Bigger font like Instagram
        textBox.textColor = .white
        textBox.textAlignment = .left
        textBox.isScrollEnabled = false // Ensures expansion instead of scrolling
        textBox.isEditable = true
        textBox.delegate = self
        textBox.backgroundColor = .clear
        textBox.layer.cornerRadius = 5
        textBox.returnKeyType = .default // Allow new lines
        
        // Setting the frame for the new text box
        textBox.frame = CGRect(
            x: (bounds.width - 250) / 2,
            y: (bounds.height - 50) / 4 - 80,
            width: 250,
            height: 50
        )
        
        addSubview(textBox)
       // delegate?.addTextViewToParent(textView: textBox)
        // Pan Gesture for moving
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleTextBoxPan(_:)))
        textBox.addGestureRecognizer(panGesture)
        
        // Pinch Gesture for resizing
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchT(_:)))
        textBox.addGestureRecognizer(pinchGesture)
        
        // Rotation Gesture for rotating the text box
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate(_:)))
        textBox.addGestureRecognizer(rotationGesture)
    }
    
   
    
    @objc func handleRotate(_ sender: UIRotationGestureRecognizer) {
        guard let textBox = sender.view else { return }
        // Apply the rotation transformation to the text box
        textBox.transform = textBox.transform.rotated(by: sender.rotation)
        // Reset the rotation to 0 after applying it to prevent continuous rotation
        sender.rotation = 0
    }
    
    @objc private func handleTextBoxPan(_ gesture: UIPanGestureRecognizer) {
        //    guard let textBox = textBox else { return }
        let translation = gesture.translation(in: self)
        // Move text box freely
        textBox.center = CGPoint(x: textBox.center.x + translation.x,
                                 y: textBox.center.y + translation.y)
        gesture.setTranslation(.zero, in: self)
        // Define trash bin hit area
        let trashDetectionFrame = trashBinView.frame.insetBy(dx: -70, dy: -150)
        switch gesture.state {
        case .changed:
            trashBinView.isHidden = false
            if textBox.frame.intersects(trashDetectionFrame) {
                textBox.alpha = 0.5 // Fade effect to indicate it's in the trash area
                triggerHapticFeedback() // Trigger haptic feedback when near the trash bin
            } else {
                textBox.alpha = 1.0
            }
            
        case .ended, .cancelled:
            trashBinView.isHidden = true
            if textBox.frame.intersects(trashDetectionFrame) {
                deleteTextBox(textBox) // Delete only when the user lifts their finger
            } else {
                textBox.alpha = 1.0 // Restore full opacity if not deleted
            }
        default:
            break
        }
    }
    
    func deleteTextBox(_ textBox: UIView) {
        triggerHapticFeedback() // Trigger feedback when deleting
        textBox.removeFromSuperview()
        trashBinView.isHidden = true
    }
    
    @objc private func handlePinchT(_ gesture: UIPinchGestureRecognizer) {
        // guard let textBox = textBox else { return }
        
        // Scale text and frame size
        textBox.transform = textBox.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1.0
    }
    
    func setupTrashBin() {
        trashBinView = UIImageView(image: UIImage(systemName: "trash.fill"))
        trashBinView.tintColor = .systemRed
        
        let tabBarHeight: CGFloat = 110  // Your tab bar height
        let binPadding: CGFloat = 20     // Padding above the tab bar
        
        let binY = frame.height - tabBarHeight - binPadding - 60 // Adjusted Y position
        
        trashBinView.frame = CGRect(x: (frame.width / 2) - 30, y: binY, width: 60, height: 60)
        trashBinView.isHidden = true
        addSubview(trashBinView)
    }
    
    func triggerHapticFeedback() {
        // Use the heavy impact style for a stronger, one-time haptic feedback
        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedbackGenerator.prepare() // Prepares the generator for immediate feedback
        impactFeedbackGenerator.impactOccurred() // Trigger the feedback
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            keyboardHeight = keyboardFrame.height
            //  adjustToolbarPosition()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        //  adjustToolbarPosition()
        fontSizeSlider.isHidden = true
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        toolbar.isHidden = false
        fontSizeSlider.isHidden = false
        if textView.text == "Tap to edit" {
            textView.text = ""
        }
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.clear.cgColor
        UserDefaults.standard.setValue(true, forKey: "fromText")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        UserDefaults.standard.setValue(true, forKey: "fromText")
        if textView.text.isEmpty {
            textView.text = "Tap to edit"
        }
        textView.layer.borderWidth = 0
        textView.layer.borderColor = UIColor.clear.cgColor
        
    }
    

    private func updateBackgroundPath() {
        let backgroundLayer = CAShapeLayer()
        var path = UIBezierPath()
        
        let maxWidth = textBox.frame.width
           let textSize = textBox.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
           
           // Update height constraint dynamically
        textBox.heightAnchor.constraint(equalToConstant: textSize.height).isActive = true
           
           // Define padding for background
           let padding: CGFloat = 15
           let backgroundRect = textBox.frame.insetBy(dx: -padding, dy: -padding)
           
           // Create a rounded rectangle path
            path = UIBezierPath(roundedRect: backgroundRect, cornerRadius: 12)
           
           // Animate background resizing
           CATransaction.begin()
           CATransaction.setAnimationDuration(0.2)
           backgroundLayer.path = path.cgPath
           CATransaction.commit()
       }
    
    
    func createCustomTextFrame() -> UIBezierPath {
          let path = UIBezierPath()
          
          // Get the text and font
        guard let text = textBox.text, let font = textBox.font else { return path }
          
          // Split the text into lines
          let lines = text.components(separatedBy: .newlines)
          
          // Starting point for the first line
          var yOffset: CGFloat = 0
          
          // Iterate through each line
          for line in lines {
              // Measure the width of the line
              let lineSize = (line as NSString).boundingRect(
                  with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: font.lineHeight),
                  options: .usesLineFragmentOrigin,
                  attributes: [.font: font],
                  context: nil
              )
              
              // Create a rectangle for the line
              let lineRect = CGRect(x: 0, y: yOffset, width: lineSize.width, height: font.lineHeight)
              let linePath = UIBezierPath(rect: lineRect)
              
              // Append the line path to the main path
              path.append(linePath)
              
              // Move the yOffset down for the next line
              yOffset += font.lineHeight
          }
          
          return path
      }
      
      // Function to apply the custom frame or reset to the default frame
      func applyCustomFrame(_ enabled: Bool) {
          if enabled {
              // Create and apply the custom frame
              let customPath = createCustomTextFrame()
              let shapeLayer = CAShapeLayer()
              shapeLayer.path = customPath.cgPath
              textBox.layer.mask = shapeLayer
          } else {
              // Reset to the default rectangular frame
              textBox.layer.mask = nil
          }
      }
      
//      // Button action to toggle the frame
//      @objc func toggleFrame() {
//          isCustomFrameEnabled.toggle()
//          applyCustomFrame(isCustomFrameEnabled)
//      }

    
    func textViewDidChange(_ textView: UITextView) {
        //   guard let imageView = imageView else { return }
        
        // Ensure textView size updates correctly
        let maxWidth = bounds.width - 20  // Leave padding on sides
        let newSize = textView.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
        
        // Update frame but keep it inside imageView
        var newFrame = textView.frame
        newFrame.size.width = min(newSize.width, maxWidth)
        newFrame.size.height = newSize.height
        
        let maxY = bounds.height - newFrame.height
        let maxX = bounds.width - newFrame.width
        
        // Restrict X and Y position inside imageView
        if newFrame.origin.x < 0 { newFrame.origin.x = 0 }
        if newFrame.origin.y < 0 { newFrame.origin.y = 0 }
        if newFrame.origin.x > maxX { newFrame.origin.x = maxX }
        if newFrame.origin.y > maxY { newFrame.origin.y = maxY }
        
        textView.frame = newFrame
        
    }
    

    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return true
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == fontsCollectionView {
            return fontNames.count
        }
        else {
            return alignments.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.fontsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FontCell", for: indexPath) as! FontCell
            cell.configure(with: fontNames[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlignmentCell", for: indexPath) as! AlignmentCell
            cell.backgroundColor = .systemGray6
            cell.configure(alignment: alignments[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == fontsCollectionView {
            //  textField.becomeFirstResponder()
            let fontName = fontNames[indexPath.row]
            textBox.font = UIFont(name: fontName, size: 26)
        } else if  collectionView == alignmentCollectionView {
            selectedAlignment = alignments[indexPath.row]
            textBox.textAlignment = selectedAlignment
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == fontsCollectionView {
            return CGSize(width: 180, height: 50)
        } else {
            return CGSize(width: 60, height: 60)
        }
    }
    
    
    func createToolbarItems() -> [UIBarButtonItem] {
        let button1 = UIBarButtonItem(image: UIImage(systemName: "text.aligncenter"), style: .plain, target: self, action: #selector(changeTextAlignment))
        button1.tintColor = .white
        
        let button2 = UIBarButtonItem(image: UIImage(systemName: "textformat"), style: .plain, target: self, action: #selector(showOverlay))
        button2.tintColor = .white
        button2.menu = createMenu()
        
        let button6 = UIBarButtonItem(image: UIImage(systemName: "character.textbox"), style: .plain, target: self, action: #selector(toggleFrame))
        button6.tintColor = .white
       
        
        let button3 = UIBarButtonItem(
            image: UIImage(systemName: "paintpalette"),
            menu: createMenu() // Directly attach menu
        )
        
        button3.tintColor = .white
       
        let button5 = UIBarButtonItem(image: UIImage(named: "done2"), style: .plain, target: self, action: #selector(doneBtnTapped))
        button5.tintColor = .white
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        flexibleSpace.width = 20  // Adjust the spacing
        return [button2, flexibleSpace, button3, flexibleSpace, button1,  flexibleSpace, button6, flexibleSpace, button5]
    }
    
    @objc func buttonTapped() {
        print("Toolbar button tapped")
    }
    
    @objc func doneBtnTapped() {
        ellipsisOverlay.isHidden = true
        toolbar.isHidden = true
        fontsCollectionView.isHidden = true
        textBox.resignFirstResponder()
        fontSizeSlider.isHidden = true
    }
    
    @objc func changeTextAlignment() {
        //  guard let textBox = textBox else { return }
        textBox.becomeFirstResponder()
        fontSizeSlider.isHidden = false
        // Define available alignments
        let alignments: [NSTextAlignment] = [.left, .center, .right, .justified]
        
        // Update to the next alignment
        alignmentIndex = (alignmentIndex + 1) % alignments.count
        self.textBox.textAlignment = alignments[alignmentIndex]
    }
    
    @objc func showOverlay() {
        // isOverlayVisible = true
        ellipsisOverlay.isHidden = true
        fontSizeSlider.isHidden = true
        textBox.resignFirstResponder() // Dismiss keyboard
        self.fontsCollectionView.isHidden = false
    }
    
    // Button action to toggle the frame
    @objc func toggleFrame() {
        isCustomFrameEnabled.toggle()
        applyCustomFrame(isCustomFrameEnabled)
    }
    
    func createMenu() -> UIMenu {
        fontSizeSlider.isHidden = true
        textBox.becomeFirstResponder()
        let option1Action = UIAction(title: "Choose Text Color", image: UIImage(systemName: "camera.fill")) { _ in
            print("Option 3 selected")
            UserDefaults.standard.set(false, forKey: "OverlayPressed")
            UserDefaults.standard.set(true, forKey: "FontPressed")
            self.showColorPicker()
            // self.checkCameraPermissions()
            UserDefaults.standard.set(true, forKey: "ObjPressed")
        }
        
        let option2Action = UIAction(title: "Choose Overlay Color", image: UIImage(systemName: "photo")) { _ in
            print("Option 3 selected")
            UserDefaults.standard.set(false, forKey: "FontPressed")
            UserDefaults.standard.set(true, forKey: "OverlayPressed")
            self.showColorPicker()
        }
        
        return UIMenu(title: "", children: [option1Action, option2Action])
    }
    
    @objc func showColorPicker() {
        ellipsisOverlay.isHidden = true
        textBox.resignFirstResponder()
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = backgroundColor ?? .white // Default color
        
        if let sheet = colorPicker.sheetPresentationController {
            // Define a custom medium size detent (e.g., 40% o {
            if #available(iOS 16.0, *) {
                sheet.detents = [
                    .custom(identifier: .medium) { context in
                        return 650 // Height for the medium detent
                    }
                ]
            } else {
                // Fallback on earlier versions
                sheet.detents = [.medium()]
            }
            sheet.selectedDetentIdentifier = .medium
            sheet.prefersGrabberVisible = true // Show the grabber for resizing
            sheet.preferredCornerRadius = 20 // Round the corners
            sheet.largestUndimmedDetentIdentifier = .medium // Background remains visible
        }
        self.parentViewController!.present(colorPicker, animated: true, completion: nil)
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        //  showKeyboard()
        let isFont = UserDefaults.standard.bool(forKey: "FontPressed")
        let isOverlay = UserDefaults.standard.bool(forKey: "OverlayPressed")
        if isFont == true {
            textBox.becomeFirstResponder()
            textBox.textColor = viewController.selectedColor
        } else if isOverlay == true {
            textBox.becomeFirstResponder()
            textBox.backgroundColor = viewController.selectedColor
        }
        else {
        }
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        
        let isFont = UserDefaults.standard.bool(forKey: "FontPressed")
        let isOverlay = UserDefaults.standard.bool(forKey: "OverlayPressed")
        
        if isFont == true {
            let selectedColor = viewController.selectedColor
            textBox.textColor = selectedColor
        } else if isOverlay == true {
            let selectedColor = viewController.selectedColor
            textBox.backgroundColor = selectedColor
        } else {
        }
    }
}
