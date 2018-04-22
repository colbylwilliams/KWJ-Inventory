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
    
    let functionAppNameKey      = "AMFunctionAppName"
    let databaseAccountNameKey  = "AMDatabaseAccountName"
    
    let functionAppNameKeyDefault       = "AZURE_MOBILE_FUNCTION_APP_NAME"
    let databaseAccountNameKeyDefault   = "AZURE_COSMOS_DB_ACCOUNT_NAME"
    
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        
        
        client.getProject { r in
            r.printResponseData()
            r.printResult()
        }
        
        client.getIterations { r in
            r.printResponseData()
            r.printResult()
        }
        
        let functionName = UserDefaults.standard.string(forKey: functionAppNameKey)     ?? Bundle.main.infoDictionary?[functionAppNameKey]      as? String
        let databaseName = UserDefaults.standard.string(forKey: databaseAccountNameKey) ?? Bundle.main.infoDictionary?[databaseAccountNameKey]  as? String
        
        storeDatabaseAccount(functionName: functionName, databaseName: databaseName, andConfigure: true)
    }
    
    
    func storeDatabaseAccount(functionName: String?, databaseName: String?, andConfigure configure: Bool = false) {
        
        print("storeDatabaseAccount functionName: \(functionName ?? "nil") databaseName: \(databaseName ?? "nil")")
        
        UserDefaults.standard.set(functionName, forKey: functionAppNameKey)
        UserDefaults.standard.set(databaseName, forKey: databaseAccountNameKey)
        
        if let f = functionName, f != functionAppNameKeyDefault, let d = databaseName, d != databaseAccountNameKeyDefault, let baseUrl = URL(string: "https://\(f).azurewebsites.net") {
            if configure { AzureData.configure(forAccountNamed: d, withPermissionProvider: DefaultPermissionProvider(withBaseUrl: baseUrl)) }
        } else {
            AzureData.reset()
        }
        
        showApiKeyAlert(UIApplication.shared)
    }
    
    
    func showApiKeyAlert(_ application: UIApplication) {
        
        if AzureData.isConfigured() {
            
            if let navController = window?.rootViewController as? NavigationController {
                navController.refreshData()
            }
            
        } else {
            
            let alertController = UIAlertController(title: "Configure App", message: "Enter the Name of a Azure.Mobile function app and a Azure Cosmos DB account name. Or add the key in code in `applicationDidBecomeActive`", preferredStyle: .alert)
            
            alertController.addTextField() { textField in
                textField.placeholder = "Function App Name"
                textField.returnKeyType = .next
            }
            
            alertController.addTextField() { textField in
                textField.placeholder = "Database Name"
                textField.returnKeyType = .done
            }
            
//            alertController.addAction(UIAlertAction(title: "Get Key", style: .default) { a in
//                if let getKeyUrl = URL(string: "https://ms.portal.azure.com/#blade/HubsExtension/Resources/resourceType/Microsoft.DocumentDb%2FdatabaseAccounts") {
//                    UIApplication.shared.open(getKeyUrl, options: [:]) { opened in
//                        print("Opened GetKey url successfully: \(opened)")
//                    }
//                }
//            })
            
            alertController.addAction(UIAlertAction(title: "Done", style: .default) { a in
                
                self.storeDatabaseAccount(functionName: alertController.textFields?.first?.text, databaseName: alertController.textFields?.last?.text, andConfigure: true)
            })
            
            window?.rootViewController?.present(alertController, animated: true) { }
        }
    }
}
