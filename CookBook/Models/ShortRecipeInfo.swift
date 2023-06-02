//
//  ShortRecipeInfo.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 03.06.2023.
//

import Foundation

public struct ShortRecipeInfo {
    public var recipeID: String
    public var recipeName: String
    public var imageURL: URL
    
}

extension ShortRecipeInfo: Codable {
    public enum CodingKeys: String, CodingKey {
        case recipeID = "idMeal"
        case recipeName = "strMeal"
        case imageURL = "strMealThumb"
    }
}



extension ShortRecipeInfo: Equatable {
    public static func == (lhs: ShortRecipeInfo, rhs: ShortRecipeInfo) -> Bool {
        lhs.recipeID == rhs.recipeID
    }
}
