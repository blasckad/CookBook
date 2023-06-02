//
//  IngredientAmountItemViewModel.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 06.06.2023.
//

import UIKit

public class IngredientAmountItemViewModel: ItemViewModel {
    
    public override var reuseIdentifier: String {
        IngredientAmountCell.reuseIdentifier
    }
    
    private var mostRecentCell: IngredientAmountCell?
    
    public let ingredientAmount: IngredientAmount
    
    public init(ingredientAmount: IngredientAmount) {
        self.ingredientAmount = ingredientAmount
    }
    
    
    public override func setup(_ cell: UICollectionReusableView, in collectionView: UICollectionView, at indexPath: IndexPath) {
        guard let cell = cell as? IngredientAmountCell else { return }
      
        mostRecentCell = cell
        
        cell.ingredientNameLabel.text = ingredientAmount.name
        cell.ingredientAmountLabel.text = ingredientAmount.amount
        
        
       
        
        cell.accessibilityLabel = "\(ingredientAmount.name). \(ingredientAmount.amount)"
        cell.accessibilityHint = nil
                
    }
    
    public override func hash(into hasher: inout Hasher) {
        hasher.combine(ingredientAmount.name)
    }
}

public func == (lhs: IngredientAmountItemViewModel, rhs: IngredientAmountItemViewModel) -> Bool {
    lhs.ingredientAmount.name == rhs.ingredientAmount.name
}


