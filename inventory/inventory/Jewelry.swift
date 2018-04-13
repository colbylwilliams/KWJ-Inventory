//
//  Jewelry.swift
//  Inventory
//
//  Created by Colby L Williams on 4/12/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import Foundation
import AzureData

class Jewelry: Document {
    
    static let databaseId = "Jewelry"
    static let collectionId = "Jewelry"
    
    var name: String?
    var code: String?
    var price: Double?
    var inventory: Int?
    var jewelryType: JewelryType?
    
    public override init () { super.init() }
    public override init (_ id: String) { super.init(id) }
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name        = try container.decode(String?.self, forKey: .name)
        code        = try container.decode(String?.self, forKey: .code)
        price       = try container.decode(Double?.self, forKey: .price)
        inventory   = try container.decode(Int?.self, forKey: .inventory)
        
        if let decoded = try? container.decode(String?.self, forKey: .jewelryType), let jtype = decoded {
            jewelryType = JewelryType(rawValue: jtype)
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(code, forKey: .code)
        try container.encode(price, forKey: .price)
        try container.encode(inventory, forKey: .inventory)
        try container.encode(jewelryType?.rawValue, forKey: .jewelryType)
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case code
        case price
        case inventory
        case jewelryType
    }
}

enum JewelryType: String {
    case earring    = "earring"
    case necklace   = "necklace"
    case ring       = "ring"
    case bracelet   = "bracelet"
}
