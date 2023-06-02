//
//  RecipeByNameRequest.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 04.06.2023.
//

import Foundation

public struct RecipesByNameRequest: APIRequest {
    public typealias Response = RecipesByNameResponse
    
    public var path: String { "/api/json/v1/1/search.php" }
    
    public var queryItems: [URLQueryItem]? { [URLQueryItem(name: "s", value: recipeName)] }
    
    public var recipeName: String
}
