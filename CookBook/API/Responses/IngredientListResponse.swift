//
//  IngredientListResponse.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 04.06.2023.
//

import Foundation

public struct IngredientListResponse {
    public var ingredientInfos: [IngredientInfo]
}

extension IngredientListResponse: Decodable {
    public enum CodingKeys: String, CodingKey {
        case ingredientInfos = "meals"
    }
}
