//
//  SectionViewModel.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 02.06.2023.
//

import UIKit

public class SectionViewModel: SectionProtocol, Hashable {
    public let uniqueSectionName: String
    
    public var headerItem: ItemViewModel? = nil
    
    public var footerItem: ItemViewModel? = nil
    
    public var items: [ItemViewModel] = []
    
    public init(uniqueSectionName: String) {
        self.uniqueSectionName = uniqueSectionName
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uniqueSectionName)
    }
}

public func == (lhs: SectionViewModel, rhs: SectionViewModel) -> Bool {
    return lhs.uniqueSectionName == rhs.uniqueSectionName
}
