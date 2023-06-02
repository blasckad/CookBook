//
//  NamedSubsectionHeader.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 05.06.2023.
//

import UIKit

public class NamedSubsectionHeader: UICollectionReusableView {
    
    public let nameLabel: UILabel = {
        let label = UILabel()
        let staticFont = UIFont.systemFont(ofSize: 20, weight: .semibold)
        let dynamicFont = UIFontMetrics(forTextStyle: .title3).scaledFont(for: staticFont)
        label.font = dynamicFont
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = false
        return label
    }()
    
    
    public static let reuseIdentifier = "SubsectionHeader"
    public static let elementKind = UICollectionView.elementKindSectionHeader
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    
    private func setupLayout() {
        isAccessibilityElement = true
        
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8)
        ])
    }
}

