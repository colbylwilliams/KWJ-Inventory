//
//  ViewControllerExtensions.swift
//  Inventory
//
//  Created by Colby L Williams on 4/12/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import Foundation
import UIKit
import AzureData

extension UIViewController {
    
    func showErrorAlert (_ error: Error) {
        
        var title = "Error"
        var message = error.localizedDescription
        
        if let documentError = error as? DocumentClientError {
            title += ": \(documentError.kind)"
            message = documentError.message
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true) { }
    }
}
