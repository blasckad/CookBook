//
//  CookingInstructionsItemViewModel.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 06.06.2023.
//

import UIKit



public class CookingInstructionsItemViewModel: ItemViewModel {
    
    public override var reuseIdentifier: String {
        CookingInstructionsCell.reuseIdentifier
    }
    
    public let recipeInfo: FullRecipeInfo
    
    
    public init(recipeInfo: FullRecipeInfo) {
        self.recipeInfo = recipeInfo
    }
    
    
    public override func setup(_ cell: UICollectionReusableView, in collectionView: UICollectionView, at indexPath: IndexPath) {
        guard let cell = cell as? CookingInstructionsCell else { return }
        
        
        cell.cookingInstructionsLabel.text = recipeInfo.cookingInstructions
    }
    
    public override func hash(into hasher: inout Hasher) {
        hasher.combine(recipeInfo)
    }
}

public func == (lhs: CookingInstructionsItemViewModel, rhs: CookingInstructionsItemViewModel) -> Bool {
    lhs.recipeInfo == rhs.recipeInfo
}

