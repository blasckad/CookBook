//
//  CategoryItemViewModel.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 05.06.2023.
//

import UIKit

public class CategoryItemViewModel: ItemViewModel {
    
    public override var reuseIdentifier: String {
        CategoryCell.reuseIdentifier
    }
    
    private var image: UIImage?
    
    private var hasRequestedImage = false
    private var mostRecentCell: CategoryCell?
    
    public let categoryInfo: CategoryInfo
    
    public init(categoryInfo: CategoryInfo) {
        self.categoryInfo = categoryInfo
    }
    
    public override func setup(_ cell: UICollectionReusableView, in collectionView: UICollectionView, at indexPath: IndexPath) {
        guard let cell = cell as? CategoryCell else { return }
        
        mostRecentCell = cell
        
        cell.categoryNameLabel.text = categoryInfo.categoryName
        
        if let image = image {
            cell.categoryImageView.image = image
            cell.categoryImageView.backgroundColor = .white
        } else {
            cell.categoryImageView.image = nil
            cell.categoryImageView.backgroundColor = .systemGray4
        }
        
        cell.accessibilityLabel = categoryInfo.categoryName
        cell.accessibilityHint = NSLocalizedString("Button", comment: "")
        
        
        guard categoryInfo != CategoryInfo.empty,
              !hasRequestedImage else { return }
        
        hasRequestedImage = true
        ArbitraryImageRequest(imageURL: categoryInfo.imageURL).send { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    if let mostRecentCell = self.mostRecentCell,
                       collectionView.indexPath(for: mostRecentCell) == indexPath {
                        mostRecentCell.categoryImageView.image = image
                        mostRecentCell.categoryImageView.backgroundColor = .white
                    }
                }
                self.image = image
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    public override func hash(into hasher: inout Hasher) {
        hasher.combine(categoryInfo)
    }
}

public func == (lhs: CategoryItemViewModel, rhs: CategoryItemViewModel) -> Bool {
    lhs.categoryInfo == rhs.categoryInfo
}

