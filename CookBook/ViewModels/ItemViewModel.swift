//
//  ItemViewModel.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 02.06.2023.
//

import UIKit

public class ItemViewModel: ItemProtocol, Hashable {
    public var reuseIdentifier: String {
        fatalError("reuseIdentifier for ItemViewModel has not been set")
    }
    
    public func setup(_ cell: UICollectionReusableView, in collectionView: UICollectionView, at indexPath: IndexPath) {
        fatalError("setup(:in:at:) for ItemViewModel has not been implemented")
    }
    
    public func hash(into hasher: inout Hasher) {
        fatalError("hash(into:) for ItemViewModel has not been implemented")
    }
}

public func == (lhs: ItemViewModel, rhs: ItemViewModel) -> Bool {
    fatalError("equality operator for ItemViewModel has not been implemented")
}

