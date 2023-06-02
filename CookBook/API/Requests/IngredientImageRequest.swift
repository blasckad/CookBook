//
//  IngredientImageRequest.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 06.06.2023.
//

import UIKit

public struct IngredientImageRequest: APIRequest {
    public typealias Response = UIImage
    
    public var path: String { "/images/ingredients/\(ingredientName).png" }
    
    public var ingredientName: String
}
