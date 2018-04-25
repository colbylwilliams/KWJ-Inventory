//
//  ProductTableViewController.swift
//  Inventory
//
//  Created by Colby L Williams on 4/22/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import Foundation
import UIKit
import AzureData
import Whisper


class ProductTableViewController : UITableViewController {

    @IBOutlet var addButton: UIBarButtonItem!
    
    var products: [Product] { return ProductManager.shared.products }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "KWJ"
        
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ProductManager.shared.clearSelectedProduct()
    }
    
    
    func refreshData() {
        ProductManager.shared.refresh {
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    
    @IBAction func refreshControlValueChanged(_ sender: Any) {
        refreshData()
    }
    
    @IBAction func refreshModelButtonTouched(_ sender: Any) {
        ProductManager.shared.trainAndDownloadCoreMLModel(withName: "kwjewelry", progressUpdate: self.displayMessage, self.displayFinalMessage)
    }
    
    let messageColor = UIColor(red: 255/255, green: 147/255, blue: 0/255,   alpha: 1)
    let successColor = UIColor(red: 0/255,   green: 150/255, blue: 255/255, alpha: 1)
    let failureColor = UIColor(red: 255/255, green: 126/255, blue: 121/255, alpha: 1)
    
    func displayMessage(message: String) {
        displayMessage(message: message, color: messageColor)
    }

    func displayFinalMessage(success: Bool, message: String) {
        displayMessage(message: message, color: success ? successColor : failureColor)
        displayMessage(message: nil)
    }

    func displayMessage(message: String?, color: UIColor = .red) {
        
        guard let navController = navigationController else {
            return
        }
        
        guard let m = message, !m.isEmpty else {
            DispatchQueue.main.async {
                Whisper.hide(whisperFrom: navController, after: 4)
            }
            return
        }

        DispatchQueue.main.async {
            Whisper.show(whisper: Message(title: m, backgroundColor: color), to: navController, action: .present)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return products.count }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
        
        let product = products[indexPath.row]
        
        cell.textLabel?.text = product.name ?? product.id
        cell.detailTextLabel?.text = ProductManager.shared.currencyFormatter.string(from: NSNumber(value: product.price ?? 0))
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction.init(style: .destructive, title: "Delete") { (action, view, callback) in
            self.deleteResource(at: indexPath, from: tableView, callback: callback)
        }
        return UISwipeActionsConfiguration(actions: [ action ] );
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteResource(at: indexPath, from: tableView)
        }
    }
    
    
    func deleteResource(at indexPath: IndexPath, from tableView: UITableView, callback: ((Bool) -> Void)? = nil) {
        ProductManager.shared.delete(productAt: indexPath.row) { success in
            if success {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            callback?(success)
        }
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let index = tableView.indexPath(for: cell) {
            ProductManager.shared.selectedProduct = products[index.row]
        }
    }
}


