//
//  AnyCodingKey.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 03.06.2023.
//

import Foundation

public struct AnyCodingKey: CodingKey {
    public var stringValue: String
    
    public init(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    public var intValue: Int?
    
    public init(intValue: Int) {
        self.intValue = intValue
        self.stringValue = "\(intValue)"
    }
}
