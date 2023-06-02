//
//  ShortRecipeInfoViewModel.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 05.06.2023.
//

import UIKit

public class ShortRecipeInfoItemViewModel: ItemViewModel {
    
    
    public override var reuseIdentifier: String {
        ShortRecipeInfoCell.reuseIdentifier
    }
    
    private var image: UIImage?
    
    private var hasRequestedImage = false
    
    private var mostRecentCell: ShortRecipeInfoCell?
    
    public let recipeInfo: ShortRecipeInfo
    
    public init(recipeInfo: ShortRecipeInfo) {
        self.recipeInfo = recipeInfo
    }
    
    
    public override func setup(_ cell: UICollectionReusableView, in collectionView: UICollectionView, at indexPath: IndexPath) {
        guard let cell = cell as? ShortRecipeInfoCell else { return }
        
        mostRecentCell = cell
        
        cell.recipeNameLabel.text = recipeInfo.recipeName
        
        if let image = image {
            cell.recipeImageView.image = image
        } else {
            cell.recipeImageView.image = nil
        }
        
        cell.accessibilityHint = NSLocalizedString("Button", comment: "")
        cell.accessibilityLabel = recipeInfo.recipeName
        
        guard !hasRequestedImage else { return }
        
        hasRequestedImage = true
        ArbitraryImageRequest(imageURL: recipeInfo.imageURL).send { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    if let mostRecentCell = self.mostRecentCell,
                       collectionView.indexPath(for: mostRecentCell) == indexPath {
                        mostRecentCell.recipeImageView.image = image
                    }
                }
                self.image = image
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public override func hash(into hasher: inout Hasher) {
        hasher.combine(recipeInfo.recipeID)
    }
}

public func == (lhs: ShortRecipeInfoItemViewModel, rhs: ShortRecipeInfoItemViewModel) -> Bool {
    return lhs.recipeInfo.recipeID == rhs.recipeInfo.recipeID
}

