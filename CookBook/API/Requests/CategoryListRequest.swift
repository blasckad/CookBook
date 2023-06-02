//
//  CategoryListRequest.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 04.06.2023.
//

import Foundation

public struct CategoryListRequest: APIRequest {
    public typealias Response = CategoryListResponse    
    public var path: String { "/api/json/v1/1/categories.php" }
}
