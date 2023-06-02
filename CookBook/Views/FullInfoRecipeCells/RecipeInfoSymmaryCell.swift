//
//  RecipeInfoSymmaryCell.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 06.06.2023.
//

import UIKit

public class RecipeInfoSummaryInfoCell: UICollectionViewCell {
    
    
    public let recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    public let recipeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 2
        return label
    }()
    
    public let recipeAreaLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        return label
    }()
    
    public let recipeCategoryLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        return label
    }()
    
    public let addToSavedButton: UIButton = {
        let button = UIButton()
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: UIFont.TextStyle.title1.metrics.scaledValue(for: 22), weight: .bold, scale: .default)
        button.setImage(UIImage(systemName: "square.and.arrow.down", withConfiguration: symbolConfiguration), for: .normal)
        button.accessibilityLabel = NSLocalizedString("Add to Saved", comment: "")
        return button
    }()
    
    public let isCurrentRecipeAddedToSaved = false
    
    public var imageTapGestureRecognizer: UITapGestureRecognizer?
    
    
    public static let reuseIdentifier = "RecipeInfoSummary"
    
    public static let imageSize: CGFloat = 120
    public static var textHeight: CGFloat {
        UILabel.labelHeight(for: .preferredFont(forTextStyle: .title2)) * 2 + (UILabel.labelHeight(for: .preferredFont(forTextStyle: .body)) + 8) * 2 + 8 + 8
    }
    
    
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
        
        
        addSubview(recipeImageView)
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        recipeImageView.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            recipeImageView.topAnchor.constraint(equalTo: topAnchor),
            recipeImageView.heightAnchor.constraint(equalToConstant: 330),
            recipeImageView.widthAnchor.constraint(equalToConstant: 360)
        ])
        
        
        addSubview(recipeNameLabel)
        recipeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recipeNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            recipeNameLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 12),
            recipeNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36)
        ])
        
        
        addSubview(addToSavedButton)
        addToSavedButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
            addToSavedButton.firstBaselineAnchor.constraint(equalTo: recipeNameLabel.firstBaselineAnchor),
            addToSavedButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])


        recipeImageView.setContentHuggingPriority(UILayoutPriority(752), for: .horizontal)
        recipeNameLabel.setContentHuggingPriority(UILayoutPriority(750), for: .horizontal)
        addToSavedButton.setContentHuggingPriority(UILayoutPriority(751), for: .horizontal)

        let areaLabelHeight = UILabel.labelHeight(for: recipeAreaLabel.font)

        let areaEffect = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        areaEffect.clipsToBounds = true
        areaEffect.layer.cornerRadius = (areaLabelHeight + 8) / 2

        addSubview(areaEffect)
        areaEffect.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            areaEffect.leadingAnchor.constraint(equalTo: recipeNameLabel.leadingAnchor),
            areaEffect.topAnchor.constraint(equalTo: recipeNameLabel.bottomAnchor, constant: 8),
            areaEffect.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])

        areaEffect.contentView.addSubview(recipeAreaLabel)
        recipeAreaLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeAreaLabel.preferredMaxLayoutWidth = recipeAreaLabel.frame.size.width

        NSLayoutConstraint.activate([
            recipeAreaLabel.leadingAnchor.constraint(equalTo: areaEffect.leadingAnchor, constant: 12),
            recipeAreaLabel.trailingAnchor.constraint(equalTo: areaEffect.trailingAnchor, constant: -12),
            recipeAreaLabel.topAnchor.constraint(equalTo: areaEffect.topAnchor, constant: 4),
            recipeAreaLabel.bottomAnchor.constraint(equalTo: areaEffect.bottomAnchor, constant: -4)
        ])


        let categoryEffect = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        categoryEffect.clipsToBounds = true
        categoryEffect.layer.cornerRadius = (areaLabelHeight + 8) / 2

        addSubview(categoryEffect)
        categoryEffect.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            categoryEffect.leadingAnchor.constraint(equalTo: areaEffect.trailingAnchor, constant: 8),
            categoryEffect.topAnchor.constraint(equalTo: recipeNameLabel.bottomAnchor, constant: 8),
            categoryEffect.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])

        categoryEffect.contentView.addSubview(recipeCategoryLabel)
        recipeCategoryLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            recipeCategoryLabel.leadingAnchor.constraint(equalTo: categoryEffect.leadingAnchor, constant: 12),
            recipeCategoryLabel.trailingAnchor.constraint(equalTo: categoryEffect.trailingAnchor, constant: -12),
            recipeCategoryLabel.topAnchor.constraint(equalTo: categoryEffect.topAnchor, constant: 4),
            recipeCategoryLabel.bottomAnchor.constraint(equalTo: categoryEffect.bottomAnchor, constant: -4)
        ])
    }
    
    func updateAddToSavedButton(isAddedToSaved: Bool) {
        let sfSymbolName = isAddedToSaved ? "square.and.arrow.down.fill" : "square.and.arrow.down"
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: UIFont.TextStyle.title1.metrics.scaledValue(for: 22), weight: .semibold, scale: .default)
        addToSavedButton.setImage(UIImage(systemName: sfSymbolName, withConfiguration: symbolConfiguration), for: .normal)
        addToSavedButton.accessibilityLabel = isAddedToSaved ? NSLocalizedString("Remove from Saved", comment: "") : NSLocalizedString("Add to Saved", comment: "")
    }

}
