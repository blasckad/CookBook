//
//  CategoryInfo.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 03.06.2023.
//

import Foundation

public struct CategoryInfo {
    public var categoryName: String
    public var categoryDescription: String
    public var imageURL: URL
    
    public static let empty = CategoryInfo(categoryName: " ", categoryDescription: " ", imageURL: URL(string: "https://example.org")!)
}

extension CategoryInfo: Decodable {
    public enum CodingKeys: String, CodingKey {
        case categoryName = "strCategory"
        case categoryDescription = "strCategoryDescription"
        case imageURL = "strCategoryThumb"
    }
}

extension CategoryInfo: Hashable {
    public static func == (lhs: CategoryInfo, rhs: CategoryInfo) -> Bool {
        lhs.categoryName == rhs.categoryName
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(categoryName)
    }
}
