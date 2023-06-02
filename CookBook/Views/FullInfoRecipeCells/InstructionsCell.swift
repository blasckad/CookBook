//
//  InstructionsCell.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 06.06.2023.
//

import UIKit

public class CookingInstructionsCell: UICollectionViewCell {
    
    public let cookingInstructionsLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    
    
    
    public static let reuseIdentifier = "CookingInstructionsCell"
    
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    public convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    
    public override func layoutSubviews() {
        setupLayout()
    }
    
    private func setupLayout() {
        
        addSubview(cookingInstructionsLabel)
        cookingInstructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cookingInstructionsLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            cookingInstructionsLabel.topAnchor.constraint(equalTo: topAnchor),
            cookingInstructionsLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
       
    }
}

