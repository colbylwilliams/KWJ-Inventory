//
//  NavigationController.swift
//  Inventory
//
//  Created by Colby L Williams on 4/12/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import UIKit
import AzureData

class NavigationController: UINavigationController {

    var jewelryDocuments: [Jewelry] = []
    var jewelryCollection: DocumentCollection?
    
    func refreshData() {
        AzureData.get(collectionWithId: Jewelry.collectionId, inDatabase: Jewelry.databaseId) { response in
            if let collection = response.resource {
                self.jewelryCollection = collection
                self.refreshDocuments()
            } else if let error = response.error {
                DispatchQueue.main.async { self.showErrorAlert(error) }
            }
        }
    }
    
    func refreshDocuments() {
        self.jewelryCollection?.get(documentsAs: Jewelry.self) { response in
            if let documents = response.resource?.items {
                self.jewelryDocuments = documents
                self.printDocuments()
            } else if let error = response.error {
                DispatchQueue.main.async { self.showErrorAlert(error) }
            }
        }
    }
    
    func printDocuments() {
        for jewelry in jewelryDocuments {
            print(jewelry)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
