//
//  ProductNavigationController.swift
//  Inventory
//
//  Created by Colby L Williams on 4/23/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import Foundation
import UIKit
import Photos
import MobileCoreServices
import ImagePicker

class ProductNavigationController : UINavigationController, ImagePickerDelegate {
    
    func selectMedia() {
        
        let imagePickerController = ImagePickerController()
        
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }

    // MARK: - ImagePickerDelegate
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("ImagePickerDelegate  :::::  wrapperDidPress")
        guard images.count > 0 else { return }
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("ImagePickerDelegate  :::::  doneButtonDidPress")
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        print("ImagePickerDelegate  :::::  cancelButtonDidPress")
        imagePicker.dismiss(animated: true, completion: nil)
    }

//    func selectMedia(_ sourceType: UIImagePickerControllerSourceType) {
//
//        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
//
//        switch photoAuthorizationStatus {
//        case .authorized:
//            showMediaPicker(sourceType)
//        case .notDetermined:
//            PHPhotoLibrary.requestAuthorization { s in
//                if s == .authorized {
//                    self.showMediaPicker(sourceType)
//                } else {
//                    self.showWtfAlert()
//                }
//            }
//        default:
//            showWtfAlert()
//        }
//    }
//
//    fileprivate func showMediaPicker(_ sourceType: UIImagePickerControllerSourceType) {
//
//        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
//
//            let imagePicker = UIImagePickerController()
//
//            imagePicker.delegate = self
//            imagePicker.sourceType = sourceType
//            imagePicker.imageExportPreset = .compatible
//            imagePicker.allowsEditing = false
//
//            present(imagePicker, animated: true, completion: nil)
//        }
//    }
    
    fileprivate func dismissAndRefresh() {
        
        dismiss(animated: true) {
            (self.topViewController as? ImageCollectionViewController)?.refreshImages()
        }
    }
    
    fileprivate func showWtfAlert() {
        
        let alert = UIAlertController.init(title: "WTF Bruh?", message: "No Photo Library Authorization?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: "Fix", style: .default) { a in })
        
        present(alert, animated: true)
    }
}


// MARK: - UINavigationControllerDelegate,

//extension ProductNavigationController: UIImagePickerControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//
//        for i in info {
//            print("key: \(i.key) \t\t\t value: \(i.value)")
//        }
//
//        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage, let data = UIImageJPEGRepresentation(image, 1.0) {
//
//            ProductManager.shared.addImageForSelectedProduct(data) { r in
//                if let summary = r.resource {
//                    print(summary)
//                } else if let error = r.error {
//                    self.showErrorAlert(error)
//                }
//                DispatchQueue.main.async { self.dismissAndRefresh() }
//            }
//        } else {
//            dismissAndRefresh()
//        }
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//}


// MARK: - UIImagePickerControllerDelegate

//extension ProductNavigationController: UINavigationControllerDelegate { }
