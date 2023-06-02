//
//  ShortRecipeInfoCell.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 05.06.2023.
//

import UIKit

public class ShortRecipeInfoCell: UICollectionViewCell {
    
    public let recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isAccessibilityElement = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    public let recipeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = false
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    public static let reuseIdentifier = "ShortMealInfoCell"
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder) has not been implemented")
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
        
        
        layer.cornerRadius = 12
        layer.shadowRadius = 6
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
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
        
        
        containerView.addSubview(recipeImageView)
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            recipeImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        let bottomEffect = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
        bottomEffect.clipsToBounds = true
        
        containerView.addSubview(bottomEffect)
        bottomEffect.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomEffect.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            bottomEffect.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bottomEffect.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        
        containerView.addSubview(recipeNameLabel)
        recipeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recipeNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            recipeNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            recipeNameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
        
        NSLayoutConstraint.activate([
            bottomEffect.topAnchor.constraint(equalTo: recipeNameLabel.topAnchor, constant: -12)
        ])
    }
}

