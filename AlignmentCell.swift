//
//  AlignmentCell.swift
//  AIEraseObjects
//
//  Created by Admin on 21/02/25.
//

class AlignmentCell: UICollectionViewCell {
    private let iconView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .label
        contentView.addSubview(iconView)
        iconView.frame = contentView.bounds.insetBy(dx: 12, dy: 12)
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
        layer.cornerRadius = 8
    }
    
    @objc func configure(alignment: NSTextAlignment) {
        switch alignment {
        case .left: iconView.image = UIImage(systemName: "text.alignleft")
        case .center: iconView.image = UIImage(systemName: "text.aligncenter")
        case .right: iconView.image = UIImage(systemName: "text.alignright")
        case .justified: iconView.image = UIImage(systemName: "text.justify")
        default: iconView.image = nil
        }
    }
}
