//
//  ArbitraryImageRequest.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 04.06.2023.
//

import Foundation
import UIKit

public struct ArbitraryImageRequest: APIRequest {
    public typealias Response = UIImage
    
    public var path: String { "" }
    
    public var request: URLRequest {
        URLRequest(url: imageURL)
    }
    
    public var imageURL: URL
}
