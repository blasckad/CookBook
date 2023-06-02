//
//  NewRecipesItemViewModel.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 17.06.2023.
//

import UIKit

public class NewRecipeItemViewModel: ItemViewModel {
    
    public override var reuseIdentifier: String {
        NewRecipesCell.reuseIdentifier
    }
    
    private var image: UIImage?
    
    private var hasRequestedImage = false
    private var mostRecentCell: NewRecipesCell?
    
    public let fullRecipeInfo: FullRecipeInfo
    
    public init(fullRecipeInfo: FullRecipeInfo) {
        self.fullRecipeInfo = fullRecipeInfo
    }
    
    public override func setup(_ cell: UICollectionReusableView, in collectionView: UICollectionView, at indexPath: IndexPath) {
        guard let cell = cell as? NewRecipesCell else { return }
        
        mostRecentCell = cell
        
        cell.recipeNameLabel.text = fullRecipeInfo.recipeName
        
        if let image = image {
            cell.newRecipeImageView.image = image
            cell.newRecipeImageView.backgroundColor = .white
        } else {
            cell.newRecipeImageView.image = nil
            cell.newRecipeImageView.backgroundColor = .systemGray4
        }
        
        cell.accessibilityLabel = fullRecipeInfo.recipeName
        cell.accessibilityHint = NSLocalizedString("Button", comment: "")
        
        guard fullRecipeInfo != FullRecipeInfo.empty,
              !hasRequestedImage else { return }
        
        hasRequestedImage = true
        ArbitraryImageRequest(imageURL: fullRecipeInfo.imageURL).send { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    if let mostRecentCell = self.mostRecentCell,
                       collectionView.indexPath(for: mostRecentCell) == indexPath {
                        mostRecentCell.newRecipeImageView.image = image
                        mostRecentCell.newRecipeImageView.backgroundColor = .white
                    }
                }
                self.image = image
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    public override func hash(into hasher: inout Hasher) {
        hasher.combine(fullRecipeInfo)
    }
}

public func == (lhs: NewRecipeItemViewModel, rhs: NewRecipeItemViewModel) -> Bool {
    lhs.fullRecipeInfo == rhs.fullRecipeInfo
}

