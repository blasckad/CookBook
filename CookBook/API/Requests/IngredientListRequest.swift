//
//  IngredientListRequest.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 04.06.2023.
//

import Foundation

public struct IngredientListRequest: APIRequest {
    public typealias Response = IngredientListResponse    
    public var path: String { "/api/json/v1/1/list.php" }
    public var queryItems: [URLQueryItem]? { [URLQueryItem(name: "i", value: "list")] }
}
