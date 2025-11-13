import UIKit

class RoundedTopView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        let user_default_color =  UIColor(red:28/255.0, green:32/255.0 , blue:38/255.0, alpha:1.0)
        self.backgroundColor = user_default_color //.systemBlue // Set background color
        
        // Apply Rounded Top Corners
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: 15, height: 15))

        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        // Ensure the mask updates when view resizes
        setupView()
    }
}

class ShadowContainerView: UIView {
    let roundedView = RoundedTopView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShadow()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupShadow()
    }

    private func setupShadow() {
        self.backgroundColor = .clear // Important to make the shadow visible
        
        // Add Shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 4) // Shadow below the view
        layer.shadowRadius = 6
        layer.masksToBounds = false // Allows shadow to be visible outside bounds
        
        // Add the rounded view inside the container
        roundedView.frame = self.bounds
        roundedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(roundedView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Apply shadow to match the rounded shape
        let shadowPath = UIBezierPath(roundedRect: bounds,
                                      byRoundingCorners: [.topLeft, .topRight],
                                      cornerRadii: CGSize(width: 20, height: 20))
        layer.shadowPath = shadowPath.cgPath
    }
}

