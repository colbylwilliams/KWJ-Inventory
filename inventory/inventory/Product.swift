//
//  Product.swift
//  Inventory
//
//  Created by Colby L Williams on 4/12/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import Foundation
import AzureData

class Product: Document {
    
    static let databaseId = "ProductsDb"
    static let collectionId = "Products"
    
    var name: String?
    var tags: [String] = []
    var price: Double?
    var inventory: Double?
    var jewelryType: JewelryType?
    
    public override init () { super.init() }
    public override init (_ id: String) { super.init(id) }
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name        = try container.decode(String?.self, forKey: .name)
        tags        = try container.decode([String].self,forKey: .tags)
        price       = try container.decode(Double?.self, forKey: .price)
        inventory   = try container.decode(Double?.self, forKey: .inventory)
        
        if let decoded = try? container.decode(String?.self, forKey: .jewelryType), let jtype = decoded {
            jewelryType = JewelryType(rawValue: jtype)
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(tags, forKey: .tags)
        try container.encode(price, forKey: .price)
        try container.encode(inventory, forKey: .inventory)
        try container.encode(jewelryType?.rawValue, forKey: .jewelryType)
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case tags
        case price
        case inventory
        case jewelryType
    }
}

enum JewelryType: String {
    case earrings   = "earrings"
    case necklaces  = "necklaces"
    case rings      = "rings"
    case bracelets  = "bracelets"
    
    var singular: String {
        switch self {
        case .earrings:  return "earring"
        case .necklaces: return  "necklace"
        case .rings:     return  "ring"
        case .bracelets: return  "bracelet"
        }
    }
    
    static let all: [JewelryType] = [ .earrings, .necklaces, .rings, .bracelets ]
    static let strings: [String]  = [ JewelryType.earrings.rawValue, JewelryType.necklaces.rawValue, JewelryType.rings.rawValue, JewelryType.bracelets.rawValue ]
}

extension Product : Equatable {
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}


extension Product {
    
    enum FormTag : String {

        case name           = "name"
        case tags           = "tags"
        case price          = "price"
        case inventory      = "inventory"
        case jewelryType    = "jewelryType"
        case saveButton     = "saveButton"
        
        
        var tag: String { return self.rawValue }
        
        
        var title: String {
            switch self {
            case .name:         return "Name"
            case .tags:         return "Tags"
            case .price:        return "Price"
            case .inventory:    return "Inventory"
            case .jewelryType:  return "Type"
            case .saveButton:   return "Save"
            }
        }
        
        
        var placeholder: String {
            switch self {
            case .name:         return "Product Name"
            case .tags:         return "Tags"
            case .price:        return "$0.00"
            case .inventory:    return "0"
            case .jewelryType:  return "Type"
            case .saveButton:   return "Save"
            }
        }
    }
}
