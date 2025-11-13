//
//  FontCell.swift
//  AIEraseObjects
//
//  Created by Admin on 21/02/25.
//

// MARK: - Custom Cells
class FontCell: UICollectionViewCell {
     let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     func setupUI() {
        label.textAlignment = .center
        contentView.addSubview(label)
        label.frame = contentView.bounds.insetBy(dx: 8, dy: 8)
         label.textColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
        layer.cornerRadius = 8
    }
    
    @objc func configure(with fontName: String) {
        label.text = fontName
        label.font = UIFont(name: fontName, size: 14)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
    }
    
    override var isSelected: Bool {
       didSet {
           print("font is selected typebgcell")
           
           if(isSelected)
           {
               backgroundColor = .systemBlue //UIColor(red:130.0/255.0, green:71.0/255.0 , blue:58.0/255.0, alpha:1.0)
               label.textColor = .black
           }
           else
           {
               backgroundColor = .clear
               label.textColor = .white
           }
        }
    }
}
