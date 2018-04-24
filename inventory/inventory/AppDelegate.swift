//
//  AppDelegate.swift
//  Inventory
//
//  Created by Colby L Williams on 4/12/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import UIKit
import AzureData
import AzureMobile
import CustomVision

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        
        ProductManager.shared.configure()
    }
}
