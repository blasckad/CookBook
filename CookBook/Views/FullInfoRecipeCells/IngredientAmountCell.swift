//
//  IngredientAmountCell.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 06.06.2023.
//

import UIKit

public class IngredientAmountCell: UICollectionViewCell {
        
    
    public let ingredientNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = false
        return label
    }()
    
    public let ingredientAmountLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 2
        label.textColor = .secondaryLabel
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = false
        label.textAlignment = .right
        return label
    }()
    
    
    public var tapGestureRecognizer: UITapGestureRecognizer?
        
    public static let reuseIdentifier = "IngredientAmountCell"
        
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
        isAccessibilityElement = true
                
        addSubview(ingredientAmountLabel)
        ingredientAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ingredientAmountLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            ingredientAmountLabel.topAnchor.constraint(equalTo: topAnchor),
            ingredientAmountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 200)
        ])
                
        addSubview(ingredientNameLabel)
        ingredientNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ingredientNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            ingredientNameLabel.topAnchor.constraint(equalTo: topAnchor),
        ])
    }
}

