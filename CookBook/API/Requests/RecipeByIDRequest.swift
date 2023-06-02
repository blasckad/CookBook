//
//  RecipeByIDRequest.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 04.06.2023.
//

import Foundation

public struct RecipeByIDRequest: APIRequest {
    public typealias Response = RecipeByIDResponse
    public var path: String { "/api/json/v1/1/lookup.php" }
    public var queryItems: [URLQueryItem]? { [URLQueryItem(name: "i", value: recipeID)] }
    public var recipeID: String
}
