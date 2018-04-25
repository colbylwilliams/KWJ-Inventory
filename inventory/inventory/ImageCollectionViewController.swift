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
    
    var viewSize: CGSize!
    
    var product: Product { return ProductManager.shared.selectedProduct }
    
    var images: [CustomVision.Image] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = product.name
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.setRightBarButtonItems([cameraButton, editButtonItem], animated: false)
        
        viewSize = view.frame.size
        
        refreshImages()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if !editing, let selectedPaths = collectionView?.indexPathsForSelectedItems {
            for path in selectedPaths {
                collectionView?.deselectItem(at: path, animated: true)
            }
        }
        
        collectionView?.allowsMultipleSelection = editing
        
        navigationItem.setLeftBarButton(editing ? trashButton : nil, animated: true)
        navigationItem.setRightBarButtonItems(editing ? [editButtonItem] : [cameraButton, editButtonItem], animated: true)
        
        if let visibleItems = collectionView?.indexPathsForVisibleItems {
            collectionView?.reloadItems(at: visibleItems)
        }
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
        
        if isEditing, let selectedPaths = collectionView?.indexPathsForSelectedItems {
            
            let confirmAlert = UIAlertController(title: "Really Really?", message: "These suckers will be gone for good...", preferredStyle: .alert)
            
            confirmAlert.addAction(UIAlertAction(title: "Abort", style: .cancel) { a in
                
            })
            
            confirmAlert.addAction(UIAlertAction(title: "Delete", style: .destructive) { a in
                
                var imagesToDelete: [CustomVision.Image] = []
                
                let selectedItems = selectedPaths.map { self.images[$0.item] }
                
                for item in selectedItems {
                    
                    if let i = self.images.index(of: item) {
                        let m = self.images.remove(at: i)
                        imagesToDelete.append(m)
                        //self.thumbnailProvider.cancelCreateThumbnail(for: m)
                    }
                }
                
                DispatchQueue.main.async {
                    self.collectionView?.deleteItems(at: selectedPaths)
                }
                
                let imagesToDeleteIds = imagesToDelete.map { $0.Id }
                
                if !imagesToDeleteIds.isEmpty {
                    ProductManager.shared.visionClient.deleteImages(withIds: imagesToDeleteIds) { r in
                        print("Delete was \(r.result.isSuccess ? "Successful" : "Unsuccessful")")
                    }
                }
            })
            
            present(confirmAlert, animated: true)
        }
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
    
    //override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //media.insert(media.remove(at: sourceIndexPath.item), at: destinationIndexPath.item)
    //}
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ImageCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Layout.itemSize(forViewSize: viewSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Layout.insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.spacing
    }
}


extension CustomVision.Image : Equatable {
    public static func ==(lhs: CustomVision.Image, rhs: CustomVision.Image) -> Bool {
        return lhs.Id == rhs.Id
    }
}


struct Layout {
    
    fileprivate static let itemsPerRow: CGFloat = 3
    
    fileprivate static let top: CGFloat = 8
    fileprivate static let bottom = top
    
    fileprivate static let notchOffset: CGFloat = 30
    
    fileprivate static let notchSide = spacing + notchOffset
    
    fileprivate static let portraitInsets = UIEdgeInsets(top: top, left: spacing, bottom: bottom, right: spacing)
    fileprivate static let landscapeInsetsLeft = UIEdgeInsets(top: top, left: notchSide, bottom: bottom, right: spacing)
    fileprivate static let landscapeInsetsRight = UIEdgeInsets(top: top, left: spacing, bottom: bottom, right: notchSide)
    
    fileprivate static let portraitAvailableWidth = spacing * (itemsPerRow + 1)
    fileprivate static let landscapeAvailableWidth = (spacing * itemsPerRow) + notchSide
    
    static let spacing: CGFloat = 2
    
    static var insets: UIEdgeInsets {
        switch UIDevice.current.orientation {
        case .landscapeLeft: return landscapeInsetsLeft
        case .landscapeRight: return landscapeInsetsRight
        default: return portraitInsets
        }
    }
    
    static func itemSize(forViewSize viewSize: CGSize) -> CGSize {
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            let size = (viewSize.width - landscapeAvailableWidth) / itemsPerRow
            return CGSize(width: size, height: size)
        default:
            let size = (viewSize.width - portraitAvailableWidth) / itemsPerRow
            return CGSize(width: size, height: size)
        }
    }
}


// MARK: - ImageCollectionViewCell

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
