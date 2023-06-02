//
//  NamedSubsectionNamed.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 05.06.2023.
//

import UIKit

public class NamedSubsectionItemViewModel: ItemViewModel {
    
    public override var reuseIdentifier: String {
        NamedSubsectionHeader.reuseIdentifier
    }
    
    public let sectionName: String
    
    public init(sectionName: String) {
        self.sectionName = sectionName
    }
    
    public override func setup(_ cell: UICollectionReusableView, in collectionView: UICollectionView, at indexPath: IndexPath) {
        guard let cell = cell as? NamedSubsectionHeader else { return }
        
        cell.nameLabel.text = sectionName
        
        cell.accessibilityLabel = "\(sectionName)"
    }
    
    public override func hash(into hasher: inout Hasher) {
        hasher.combine(sectionName)
    }
}

public func == (lhs: NamedSubsectionItemViewModel, rhs: NamedSubsectionItemViewModel) -> Bool {
    return lhs.sectionName == rhs.sectionName
}
