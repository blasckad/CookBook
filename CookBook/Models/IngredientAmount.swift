//
//  IngredientAmount.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 03.06.2023.
//

import Foundation

public struct IngredientAmount {
    public var name: String
    public var amount: String
}

extension IngredientAmount: Equatable { }
