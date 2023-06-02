//
//  NewRecipesCell.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 17.06.2023.
//


import UIKit

public class NewRecipesCell: UICollectionViewCell {
    public static let reuseIdentifier = "NewRecipesCell"
        
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
    
    let recipeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = false
        label.numberOfLines = 3
        return label
    }()
    
    public let newRecipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray4
        imageView.isAccessibilityElement = false
        return imageView
    }()
    
    
    private func setupLayout() {
        isAccessibilityElement = true
        
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.masksToBounds = false
        
        let containerView = UIView()
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        containerView.backgroundColor = .systemGray4
        
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        containerView.addSubview(newRecipeImageView)
        newRecipeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newRecipeImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            newRecipeImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            newRecipeImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            newRecipeImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        let labelEffect = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        labelEffect.translatesAutoresizingMaskIntoConstraints = false
        labelEffect.clipsToBounds = true
        
        let labelHeight = UILabel.labelHeight(for: recipeNameLabel.font)
        labelEffect.layer.cornerRadius = (labelHeight + 8) / 2
        
        containerView.addSubview(labelEffect)
        labelEffect.contentView.addSubview(recipeNameLabel)
        
        recipeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recipeNameLabel.leadingAnchor.constraint(equalTo: labelEffect.leadingAnchor, constant: 16),
            recipeNameLabel.bottomAnchor.constraint(equalTo: labelEffect.bottomAnchor, constant: -8),
            recipeNameLabel.trailingAnchor.constraint(equalTo: labelEffect.trailingAnchor, constant: -16),
            recipeNameLabel.topAnchor.constraint(equalTo: labelEffect.topAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            labelEffect.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            labelEffect.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
        ])
        
        
    }
    
    
}
