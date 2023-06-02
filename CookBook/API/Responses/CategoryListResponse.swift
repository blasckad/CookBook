//
//  CategoryListResponse.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 04.06.2023.
//

import Foundation

public struct CategoryListResponse {
    public var categoryInfos: [CategoryInfo]
}

extension CategoryListResponse: Decodable {
    public enum CodingKeys: String, CodingKey {
        case categoryInfos = "categories"
    }
}
