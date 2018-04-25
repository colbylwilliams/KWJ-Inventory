//
//  CurrencyFormatter.swift
//  Inventory
//
//  Created by Colby L Williams on 4/22/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import Foundation
import Eureka

class CurrencyFormatter : NumberFormatter, FormatterProtocol {
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, range rangep: UnsafeMutablePointer<NSRange>?) throws {
        
        guard obj != nil else { return }
        
        var str = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        
        if !string.isEmpty, numberStyle == .currency && !string.contains(currencySymbol) {
            
            // Check if the currency symbol is at the last index
            if let formattedNumber = self.string(from: 1), String(formattedNumber[formattedNumber.index(before: formattedNumber.endIndex)...]) == currencySymbol {
                
                // This means the user has deleted the currency symbol. We cut the last number and then add the symbol automatically
                str = String(str[..<str.index(before: str.endIndex)])
            }
        }
        
        obj?.pointee = NSNumber(value: (Double(str) ?? 0.0)/Double(pow(10.0, Double(minimumFractionDigits))))
    }
    
    func getNewPosition(forPosition position: UITextPosition, inTextInput textInput: UITextInput, oldValue: String?, newValue: String?) -> UITextPosition {
        return textInput.position(from: position, offset:((newValue?.count ?? 0) - (oldValue?.count ?? 0))) ?? position
    }
}
