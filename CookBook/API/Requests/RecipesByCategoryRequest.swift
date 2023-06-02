//
//  RecipesByCategoryRequest.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 04.06.2023.
//

import Foundation

public struct RecipesByCategoryRequest: APIRequest {
    public typealias Response = RecipesByCategoryResponse
    
    public var path: String { "/api/json/v1/1/filter.php" }
    
    public var queryItems: [URLQueryItem]? { [URLQueryItem(name: "c", value: category)] }
    
    public var category: String
}
