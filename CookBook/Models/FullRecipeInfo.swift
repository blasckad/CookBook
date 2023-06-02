//
//  FullRecipeInfo.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 03.06.2023.
//

import Foundation

public struct FullRecipeInfo {
    
    public var recipeID: String
    
    public var recipeName: String
    
    public var category: String
    
    public var countryInfo: CountryInfo
    
    public var cookingInstructions: String
    
    public var imageURL: URL
    
    public var ingredients: [IngredientAmount]
    
    public static let empty = FullRecipeInfo(recipeID: "", recipeName: " ", category: "    ", countryInfo: CountryInfo.empty, cookingInstructions: "", imageURL: URL(string: "https://example.org")!, ingredients: [])
}

extension FullRecipeInfo: Decodable {
    public init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: AnyCodingKey.self)
        
        recipeID = try values.decode(String.self, forKey: AnyCodingKey(stringValue: "idMeal"))
        recipeName = try values.decode(String.self, forKey: AnyCodingKey(stringValue: "strMeal"))
        category = try values.decode(String.self, forKey: AnyCodingKey(stringValue: "strCategory"))
        let countryString = try values.decode(String.self, forKey: AnyCodingKey(stringValue: "strArea"))
        countryInfo = CountryInfo(name: countryString)
        cookingInstructions = try values.decode(String.self, forKey: AnyCodingKey(stringValue: "strInstructions"))
        imageURL = try values.decode(URL.self, forKey: AnyCodingKey(stringValue: "strMealThumb"))
        
        ingredients = [IngredientAmount]()
        
        for i in 1...20 {
            var ingredient = try values.decode(String?.self, forKey: AnyCodingKey(stringValue: "strIngredient\(i)"))
            var amount = try values.decode(String?.self, forKey: AnyCodingKey(stringValue: "strMeasure\(i)"))
            
            ingredient = ingredient?.trimmingCharacters(in: .whitespaces)
            amount = amount?.trimmingCharacters(in: .whitespaces)
            
            guard let ingredient = ingredient,
                  let amount = amount,
                  !ingredient.isEmpty,
                  !amount.isEmpty else {
                break
            }
            
            ingredients.append(IngredientAmount(name: ingredient, amount: amount))
        }
    }
}

extension FullRecipeInfo: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        
        try container.encode(recipeID, forKey: AnyCodingKey(stringValue: "idMeal"))
        try container.encode(recipeName, forKey: AnyCodingKey(stringValue: "strMeal"))
        try container.encode(category, forKey: AnyCodingKey(stringValue: "strCategory"))
        try container.encode(countryInfo.name, forKey: AnyCodingKey(stringValue: "strArea"))
        try container.encode(cookingInstructions, forKey: AnyCodingKey(stringValue: "strInstructions"))
        try container.encode(imageURL, forKey: AnyCodingKey(stringValue: "strMealThumb"))
        
        for i in 0..<ingredients.count {
            try container.encode(ingredients[i].name, forKey: AnyCodingKey(stringValue: "strIngredient\(i + 1)"))
            try container.encode(ingredients[i].amount, forKey: AnyCodingKey(stringValue: "strMeasure\(i + 1)"))
        }
        
        for i in ingredients.count..<20 {
            try container.encode("", forKey: AnyCodingKey(stringValue: "strIngredient\(i + 1)"))
            try container.encode("", forKey: AnyCodingKey(stringValue: "strMeasure\(i + 1)"))
        }
    }
}

extension FullRecipeInfo: Hashable {
    public static func == (lhs: FullRecipeInfo, rhs: FullRecipeInfo) -> Bool {
        return lhs.recipeID == rhs.recipeID
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(recipeID)
    }
}
