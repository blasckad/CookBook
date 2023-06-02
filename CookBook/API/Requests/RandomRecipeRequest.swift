//
//  RandomRecipeRequest.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 04.06.2023.
//

import Foundation

public struct RandomRecipeRequest: APIRequest {
    public typealias Response = RandomRecipeResponse
    
    public var path: String { "/api/json/v1/1/random.php" }
}
