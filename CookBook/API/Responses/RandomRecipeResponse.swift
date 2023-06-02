//
//  RandomRecipeResponse.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 04.06.2023.
//

import Foundation

public struct RandomRecipeResponse {
    public var recipeInfo: FullRecipeInfo
}

extension RandomRecipeResponse: Decodable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: AnyCodingKey.self)
        
        let recipeInfos = try values.decode([FullRecipeInfo].self, forKey: AnyCodingKey(stringValue: "meals"))
        
        if recipeInfos.count != 1 {
            fatalError("Invalid server response")
        }
        
        recipeInfo = recipeInfos.first!
    }
}
