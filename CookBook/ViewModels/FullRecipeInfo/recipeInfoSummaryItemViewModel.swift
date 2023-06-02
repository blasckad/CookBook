//
//  recipeInfoSummaryItemViewModel.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 06.06.2023.
//

import UIKit

public class recipeInfoSummaryItemViewModel: ItemViewModel {
    
    public override var reuseIdentifier: String {
        RecipeInfoSummaryInfoCell.reuseIdentifier
    }
    
    private var image: UIImage?
    private var hasRequestedImage = false
    private var mostRecentCell: RecipeInfoSummaryInfoCell?
    
    
    private var toggleSavedAction: ((FullRecipeInfo) -> Void)? = nil
    
    public let recipeInfo: FullRecipeInfo
    
    
    public init(recipeInfo: FullRecipeInfo) {
        self.recipeInfo = recipeInfo
    }
    
    
    public override func setup(_ cell: UICollectionReusableView, in collectionView: UICollectionView, at indexPath: IndexPath) {
        guard let cell = cell as? RecipeInfoSummaryInfoCell else { return }
        
        cell.updateAddToSavedButton(isAddedToSaved: UserSettings.shared.savedRecipes.contains(recipeInfo))
        
        mostRecentCell = cell
        
        cell.recipeNameLabel.text = recipeInfo.recipeName
        cell.recipeAreaLabel.text = recipeInfo.countryInfo.prettyString
        cell.recipeCategoryLabel.text = recipeInfo.category
        
        cell.recipeAreaLabel.accessibilityLabel = recipeInfo.countryInfo.name
        cell.addToSavedButton.accessibilityLabel = UserSettings.shared.savedRecipes.contains(recipeInfo) ? NSLocalizedString("Remove from Saved", comment: "") : NSLocalizedString("Add to Saved", comment: "")
        
        cell.addToSavedButton.removeTarget(nil, action: nil, for: .allEvents)
        
        if let image = image {
            cell.recipeImageView.image = image
            cell.addToSavedButton.addTarget(self, action: #selector(toggleSaved), for: .touchUpInside)
        }
        
        guard !hasRequestedImage else { return }
        
        hasRequestedImage = true
        ArbitraryImageRequest(imageURL : recipeInfo.imageURL).send { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    if let mostRecentCell = self.mostRecentCell,
                       collectionView.indexPath(for: mostRecentCell) == indexPath {
                        mostRecentCell.recipeImageView.image = image
                        mostRecentCell.addToSavedButton.addTarget(self, action: #selector(self.toggleSaved), for: .touchUpInside)
                    }
                }
                self.image = image
            case .failure(let error):
                print(error)
            }
        }
    }
    
  
    
    public func setToggleSavedAction(_ action: @escaping (FullRecipeInfo) -> Void) {
        toggleSavedAction = action
    }
    
    @objc private func toggleSaved() {
        toggleSavedAction?(recipeInfo)
        mostRecentCell?.updateAddToSavedButton(isAddedToSaved: UserSettings.shared.savedRecipes.contains(recipeInfo))
    }
    
    public override func hash(into hasher: inout Hasher) {
        hasher.combine(recipeInfo)
    }
}

public func == (lhs: recipeInfoSummaryItemViewModel, rhs: recipeInfoSummaryItemViewModel) -> Bool {
    lhs.recipeInfo == rhs.recipeInfo
}
