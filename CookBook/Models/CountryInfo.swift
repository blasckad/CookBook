//
//  CountryInfo.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 03.06.2023.
//

import Foundation

public struct CountryInfo {
    
    // MARK: - Properties
    
    private static var nameToFlagMap = [
        "american": "🇺🇸",
        "british": "🇬🇧",
        "canadian": "🇨🇦",
        "chinese": "🇨🇳",
        "croatian": "🇭🇷",
        "dutch": "🇳🇱",
        "egyptian": "🇪🇬",
        "french": "🇫🇷",
        "greek": "🇬🇷",
        "indian": "🇮🇳",
        "irish": "🇮🇪",
        "italian": "🇮🇹",
        "jamaican": "🇯🇲",
        "japanese": "🇯🇵",
        "kenyan": "🇰🇪",
        "malaysian": "🇲🇾",
        "mexican": "🇲🇽",
        "moroccan": "🇲🇦",
        "polish": "🇵🇱",
        "portuguese": "🇵🇹",
        "russian": "🇷🇺",
        "spanish": "🇪🇸",
        "thai": "🇹🇭",
        "tunisian": "🇹🇳",
        "turkish": "🇹🇷",
        "vietnamese": "🇻🇳",
        "unknown": "🇺🇳"
    ]
    
    public var name: String
    public var flagEmoji: String
    
    public var prettyString: String {
        "\(flagEmoji) \(name.capitalized)"
    }
    
    public static let empty = CountryInfo()
    
    public init(name: String) {
        let lowercaseName = name.lowercased()
        
        if lowercaseName == "unknown" {
            self.name = "Other"
        } else {
            self.name = name
        }
        
        if let flag = Self.nameToFlagMap[lowercaseName] {
            self.flagEmoji = flag
        } else {
            self.flagEmoji = "🇺🇳"
        }
    }
    
    private init() {
        self.name = "   "
        self.flagEmoji = ""
    }
}

extension CountryInfo: Decodable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: AnyCodingKey.self)
        
        let name = try values.decode(String.self, forKey: AnyCodingKey(stringValue: "strCountry"))
        
        self.init(name: name)
    }
}
