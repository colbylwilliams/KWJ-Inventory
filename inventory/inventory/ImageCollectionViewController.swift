//
//  ImageCollectionViewController.swift
//  Inventory
//
//  Created by Colby L Williams on 4/23/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import Foundation
import UIKit
import CustomVision
import Nuke


class ImageCollectionViewController : UICollectionViewController {
    
    @IBOutlet var trashButton: UIBarButtonItem!
    @IBOutlet var cameraButton: UIBarButtonItem!
    
    var product: Product { return ProductManager.shared.selectedProduct }
    
    var images: [CustomVision.Image] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = product.name
        
        navigationItem.rightBarButtonItem = cameraButton
        
        refreshImages()
    }

    
    func refreshImages() {

        ProductManager.shared.getImagesForSelectedProduct { r in
            if let images = r.resource {
                self.images = images
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            } else if let error = r.error {
                self.showErrorAlert(error)
            }
        }
    }
    
    
    // MARK: - @IBAction
    
    @IBAction func cameraButtonTouched(_ sender: Any) {
        if let productNavController = navigationController as? ProductNavigationController {
            productNavController.selectMedia()
        }
    }

    @IBAction func trashButtonTouched(_ sender: Any) {
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageCollectionViewCell else {
            fatalError("Expected `\(ImageCollectionViewCell.self)` type for reuseIdentifier \(ImageCollectionViewCell.reuseIdentifier). Check the configuration in Main.storyboard.")
        }
        
        cell.imageView.image = nil

        let image = images[indexPath.item]
        
        cell.set(thumbnailUrl: image.ThumbnailUri, editingState: isEditing)
        
        return cell
    }
    
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !isEditing {
//            if media[indexPath.item].isMovie {
//                performSegue(withIdentifier: "AVPlayerViewController", sender: collectionView.cellForItem(at: indexPath))
//            } else {
//                performSegue(withIdentifier: "CompassPageViewController", sender: collectionView.cellForItem(at: indexPath))
//                //performSegue(withIdentifier: "CompassViewController", sender: collectionView.cellForItem(at: indexPath))
//            }
        } else if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
            cell.set(editingState: isEditing)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if isEditing, let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
            cell.set(editingState: isEditing)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        media.insert(media.remove(at: sourceIndexPath.item), at: destinationIndexPath.item)
    }
}


class ImageCollectionViewCell : UICollectionViewCell {
    
    static let reuseIdentifier = "ImageCollectionViewCell"
    
    var url: URL?
    var editing: Bool = false
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectedLabel: UILabel!
    
    func set(thumbnailUrl: URL?, editingState isEditing: Bool) {
        
        if let url = url, let thumbnailUrl = thumbnailUrl, url == thumbnailUrl, isEditing == editing {
            return
        }
        
        url = thumbnailUrl
        
        if let url = url {
            Manager.shared.loadImage(with: url, into: imageView)
        } else {
            Manager.shared.cancelRequest(for: imageView)
            imageView.image = nil
        }
        
        set(editingState: isEditing)
    }
    
    func set(editingState isEditing: Bool) {
        
        editing = isEditing
        
        imageView.alpha = isSelected ? 0.3 : 1.0
        
        selectedLabel.isHidden = !isEditing
        selectedLabel.text = isSelected ? "◉" : "◎"
    }
}
