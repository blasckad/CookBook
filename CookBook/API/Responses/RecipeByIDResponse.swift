//
//  RecipeByIDResponse.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 27.06.2023.
//

import Foundation

public struct RecipeByIDResponse {
    public var recipeInfo: FullRecipeInfo?
}

extension RecipeByIDResponse: Decodable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: AnyCodingKey.self)
        
        let recipeInfos = try values.decode([FullRecipeInfo]?.self, forKey: AnyCodingKey(stringValue: "meals"))
        
        if let recipeInfos = recipeInfos {
            recipeInfo = recipeInfos.first
        } else {
            recipeInfo = nil
        }
    }
}
