//
//  RecipeByNameResponse.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 04.06.2023.
//

import Foundation

public struct RecipesByNameResponse {
    public var recipeInfos: [FullRecipeInfo]?
}

extension RecipesByNameResponse: Decodable {
    public enum CodingKeys: String, CodingKey {
        case recipeInfos = "meals"
    }
}
