//
//  RecipesByCategoryResponse.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 04.06.2023.
//

import Foundation

public struct RecipesByCategoryResponse {
    public var recipeInfos: [ShortRecipeInfo]?
}

extension RecipesByCategoryResponse: Decodable {
    public enum CodingKeys: String, CodingKey {
        case recipeInfos = "meals"
    }
}
