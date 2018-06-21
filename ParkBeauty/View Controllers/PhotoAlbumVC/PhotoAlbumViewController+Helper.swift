//
//  PhotoAlbumViewController+Helper.swift
//  ParkBeauty
//
//  Created by Shirley on 6/20/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

// MARK: - PhotoAlbumViewController+Helper (Configure UI)

extension PhotoAlbumViewController {
    
    // MARK: createNewPlacesButton - create and set the new collection button
    
//    func createNewPlacesButton() {
//
//        var toolbarButtons: [UIBarButtonItem] = [UIBarButtonItem]()
//
//        // use empty flexible space bar button to center the new collection button
//        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
//
//        newPlacesButton = UIBarButtonItem(title: "New Collection", style: .plain, target: self, action: #selector(newCollectionPressed))
//        toolbarButtons.append(flexButton)
//        toolbarButtons.append(newPlacesButton!)
//        toolbarButtons.append(flexButton)
//        self.setToolbarItems(toolbarButtons, animated: true)
//    }
    
    // MARK: createRemovePhotosButton - create and set the remove photos button
    
//    func createRemovePhotosButton() {
//        
//        var toolbarButtons: [UIBarButtonItem] = [UIBarButtonItem]()
//        
//        // use empty flexible space bar button to center the remove photos button
//        
//        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
//        
//        removePhotosButton = UIBarButtonItem(title: "Remove Selected Photos", style: .plain, target: self, action: #selector(removePhotosPressed))
//        toolbarButtons.append(flexButton)
//        toolbarButtons.append(removePhotosButton!)
//        toolbarButtons.append(flexButton)
//        self.setToolbarItems(toolbarButtons, animated: true)
//    }
    
    // MARK: createTopBarButtons - create and set the top bar buttons
    
    func createTopBarButtons() {
        
        var leftBarButtons: [UIBarButtonItem] = [UIBarButtonItem]()
        let backButton = UIBarButtonItem(image: UIImage(named: "icon_back-arrow"), style: .plain, target: self, action: #selector(backButtonPressed))
        leftBarButtons.append(backButton)
        navigationItem.setLeftBarButtonItems(leftBarButtons, animated: true)
        
//        var rightBarButtons: [UIBarButtonItem] = [UIBarButtonItem]()
//        let infoButton = UIBarButtonItem(image: UIImage(named: "icon_info"), style: .plain, target: self, action: #selector(infoButtonPressed))
//        let visitButton = UIBarButtonItem(image: UIImage(named: "icon_plane"), style: .plain, target: self, action: #selector(postVisit))
//        rightBarButtons.append(infoButton)
//        rightBarButtons.append(visitButton)
//        navigationItem.setRightBarButtonItems(rightBarButtons, animated: true)
        //        navigationController?.toolbar.barTintColor = UIColor.white
        //        navigationController?.toolbar.tintColor = UIColor.white
    }
    
    // MARK: setUIActions - Set UI action buttons
    
    func setUIActions() {
        
//        if (isLoadingPhotos) {
            
//            newPlacesButton?.isEnabled = false
            removePhotosButton?.isEnabled = false
//        } else {
//
////            newPlacesButton?.isEnabled = true
//            removePhotosButton?.isEnabled = false
//        }
    }
    
    // MARK: setUIForDownloadingPlaces - Set user interface for downloading places
    
//    func setUIForDownloadingPlaces() {
//
//        newPlacesButton?.isEnabled = false
//        removePlacesButton?.isEnabled = false
//        placeCollectionView.reloadData()
//    }
    
    // MARK: resetUIAfterDownloadingPlaces - Reset user interface after download
    
//    func resetUIAfterDownloadingPlaces() {
//
//        newPlacesButton?.isEnabled = true
//        removePlacesButton?.isEnabled = false
//        placeCollectionView.reloadData()
//    }
    
    // MAKR: displayError - Display error
    
    func displayError(_ errorString: String?) {
        
        print(errorString!)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: setSelectedPhoto - set selected photos from collection cell selection
    
    func setSelectedPhoto(_ cell: PhotoCollectionCell, at indexPath: IndexPath) {
        
        // Set photo cell selection
        
        if let index = selectedPhotoCells.index(of: indexPath) {
            
            selectedPhotoCells.remove(at: index)
        } else {
            
            selectedPhotoCells.append(indexPath)
        }
        
        toggleSelectedPhoto(cell, at: indexPath)
    }
    
    // MARK: toggleSelectedPhoto - toggle the selected photo cell in collection view
    
    func toggleSelectedPhoto(_ cell: PhotoCollectionCell, at indexPath: IndexPath) {
        
        // Toggle photo selection
        
        if let _ = selectedPhotoCells.index(of: indexPath) {
            cell.alpha = 0.375
        } else {
            cell.alpha = 1.0
        }
    }
    
    // MARK: resetSelectedPhotoCells - reset the selected photo cell array
    
    func resetSelectedPhotoCells() {
        
        // Reset selected cells
        selectedPhotoCells.removeAll()
        photoCollectionView.reloadData()
    }
    
}

