//
//  ItemProtocol.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 02.06.2023.
//

import UIKit

public protocol ItemProtocol {

    var reuseIdentifier: String { get }

    func setup(_ cell: UICollectionReusableView, in collectionView: UICollectionView, at indexPath: IndexPath)
}
