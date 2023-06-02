//
//  SectionProtocol.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 02.06.2023.
//

import UIKit

public protocol SectionProtocol {
    
    var uniqueSectionName: String { get }
    
    var headerItem: ItemViewModel? { get }
    
    var footerItem: ItemViewModel? { get }
    
    var items: [ItemViewModel] { get }
    
    func model(forElementOfKind elementKind: String) -> ItemViewModel?
}

extension SectionProtocol {
    public func model(forElementOfKind elementKind: String) -> ItemViewModel? {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            return headerItem
        case UICollectionView.elementKindSectionFooter:
            return footerItem
        default:
            return nil
        }
    }
}
