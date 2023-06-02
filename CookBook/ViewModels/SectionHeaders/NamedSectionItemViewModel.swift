//
//  NamedSectionItemViewModel.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 05.06.2023.
//

import UIKit

public class NamedSectionItemViewModel: ItemViewModel {
    
    public override var reuseIdentifier: String {
        NamedSectionHeader.reuseIdentifier
    }
    
    public let sectionName: String
    
    public init(sectionName: String) {
        self.sectionName = sectionName
    }
    
    public override func setup(_ cell: UICollectionReusableView, in collectionView: UICollectionView, at indexPath: IndexPath) {
        guard let cell = cell as? NamedSectionHeader else { return }
        
        cell.nameLabel.text = sectionName
        
        cell.accessibilityLabel = "\(sectionName)"
    }
    
    public override func hash(into hasher: inout Hasher) {
        hasher.combine(sectionName)
    }
}

public func == (lhs: NamedSectionItemViewModel, rhs: NamedSectionItemViewModel) -> Bool {
    return lhs.sectionName == rhs.sectionName
}

