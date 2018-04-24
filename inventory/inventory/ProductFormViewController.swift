//
//  ProductFormViewController.swift
//  Inventory
//
//  Created by Colby L Williams on 4/22/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import Foundation
import Eureka

class ProductFormViewController : FormViewController {
    
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var imagesButton: UIBarButtonItem!
    
    var changed = false
    
    var product: Product { return ProductManager.shared.selectedProduct }
    
    var currencyFormatter: CurrencyFormatter { return ProductManager.shared.currencyFormatter }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let name        = Product.FormTag.name
        let tags        = Product.FormTag.tags
        let inventory   = Product.FormTag.inventory
        let type        = Product.FormTag.jewelryType
        let price       = Product.FormTag.price
        let saveButton  = Product.FormTag.saveButton
        
        form
        +++ Section("Product")
        <<< TextRow (name.tag) { row in
                row.title = name.title
                row.placeholder = name.placeholder
                row.value = product.name
            }.onChange {
                self.changed = true
                self.product.name = $0.value
            }
        <<< PickerInlineRow<String>(type.tag) { row in
                row.title = type.title
                row.value = self.product.jewelryType?.rawValue ?? JewelryType.strings[0]
                row.options = JewelryType.strings
            }.onChange {
                if let v = $0.value {
                    self.changed = true
                    self.product.jewelryType = JewelryType(rawValue: v)
                }
            }
        <<< DecimalRow(price.tag) { row in
                row.useFormatterDuringInput = true
                row.title = price.title
                row.placeholder = price.placeholder
                row.formatter = currencyFormatter
                row.value = product.price
            }.onChange {
                self.changed = true
                self.product.price = $0.value
            }
        <<< StepperRow(inventory.tag) { row in
                row.title = inventory.title
                row.value = product.inventory
            }.onChange {
                self.changed = true
                self.product.inventory = $0.value
            }
        +++ MultivaluedSection (multivaluedOptions: [.Insert, .Delete], header: tags.title, footer: "") { section in
                section.tag = tags.tag
                section.addButtonProvider = { _ in
                    return ButtonRow { row in
                        row.title = "Add Tag"
                    }.cellUpdate { cell, _ in
                        cell.textLabel?.textAlignment = .left
                    }
                }
                section.multivaluedRowToInsertAt = { _ in
                    return TagRow(UUID().uuidString) { row in
                        row.title = ""
                        row.placeholder = "tag"
                        //row.presentationMode = .segueName(segueName: "PurchaseFormViewController", onDismiss: nil)
                        }.onChange { _ in
                            self.changed = true
                        }
                }
                for tag in product.tags {
                    section
                    <<< TagRow (tag) { row in
                            row.title = ""
                            row.value = tag
                            //row.presentationMode = .segueName(segueName: "PurchaseFormViewController", onDismiss: nil)
                        }.onChange { _ in
                            self.changed = true
                        }
                }
            }
        
        if !(navigationController is ProductNavigationController) {

            form
            +++ ButtonRow(saveButton.tag) { row in
                    row.title = saveButton.title
                }.onCellSelection { _, _ in
                    self.saveAndDismiss()
                }

            navigationItem.leftBarButtonItem = cancelButton
            navigationItem.rightBarButtonItem = self.saveButton
        
        } else {
            
            title = product.name
            navigationItem.rightBarButtonItem = imagesButton
        }
    }
    

    override func rowsHaveBeenAdded(_ rows: [BaseRow], at indexes: [IndexPath]) {
        super.rowsHaveBeenAdded(rows, at: indexes)
        self.changed = true
    }

    
    override func rowsHaveBeenRemoved(_ rows: [BaseRow], at indexes: [IndexPath]) {
        super.rowsHaveBeenRemoved(rows, at: indexes)
        self.changed = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if changed && (navigationController is ProductNavigationController) {
            updateProductTags()
            ProductManager.shared.saveSelectedProduct()
        }
    }
    
    
    @IBAction func saveButtonTouchUpInside(_ sender: Any) {
        saveAndDismiss()
    }
    
    
    @IBAction func cancelButtonTouchUpInside(_ sender: Any) {
        dismiss(animated: true) { }
    }
    
    
    func saveAndDismiss() {
        updateProductTags()
        ProductManager.shared.saveSelectedProduct(self.dismiss)
    }
    
    func dismiss() {
        if navigationController is ProductNavigationController {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true) { }
        }
    }
    
    func updateProductTags () {
        
        if let tagsSection = form.sectionBy(tag: Product.FormTag.tags.tag) as? MultivaluedSection {
            
            var tags = tagsSection.values().compactMap { $0 as? String }
            
            if let name = product.name, !tags.contains(name) {
                tags.append(name)
            }
            
            if let type = product.jewelryType?.rawValue, !tags.contains(type) {
                tags.append(type)
            }
            
            product.tags = tags
        }
    }
}
