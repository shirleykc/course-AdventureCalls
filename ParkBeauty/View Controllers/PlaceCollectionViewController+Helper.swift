//
//  PlaceCollectionViewController+Helper.swift
//  ParkBeauty
//
//  Created by Shirley on 6/8/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

// MARK: - PlaceCollectionViewController+Helper (Configure UI)

extension PlaceCollectionViewController {
    
    // MARK: createNewPlacesButton - create and set the new collection button
    
    func createNewPlacesButton() {
        
        var toolbarButtons: [UIBarButtonItem] = [UIBarButtonItem]()
        
        // use empty flexible space bar button to center the new collection button
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        newPlacesButton = UIBarButtonItem(title: "New Collection", style: .plain, target: self, action: #selector(newCollectionPressed))
        toolbarButtons.append(flexButton)
        toolbarButtons.append(newPlacesButton!)
        toolbarButtons.append(flexButton)
        self.setToolbarItems(toolbarButtons, animated: true)
    }
    
    // MARK: createRemovePlacesButton - create and set the remove places button
    
    func createRemovePlacesButton() {
        
        var toolbarButtons: [UIBarButtonItem] = [UIBarButtonItem]()
        
        // use empty flexible space bar button to center the remove places button
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        removePlacesButton = UIBarButtonItem(title: "Remove Selected Places", style: .plain, target: self, action: #selector(removePlacesPressed))
        toolbarButtons.append(flexButton)
        toolbarButtons.append(removePlacesButton!)
        toolbarButtons.append(flexButton)
        self.setToolbarItems(toolbarButtons, animated: true)
    }
    
    // MARK: createBackButton - create and set the back button
    
//    func createBackButton() {
//
//        var toolbarButtons: [UIBarButtonItem] = [UIBarButtonItem]()
//        let backButton = UIBarButtonItem(image: UIImage(named: "icon_back-arrow"), style: .plain, target: self, action: #selector(backButtonPressed))
//        toolbarButtons.append(backButton)
//        navigationItem.setLeftBarButtonItems(toolbarButtons, animated: true)
//    }
    
    // MARK: createTopBarButtons - create and set the top bar buttons
    
    func createTopBarButtons() {
        
        var leftBarButtons: [UIBarButtonItem] = [UIBarButtonItem]()
        let backButton = UIBarButtonItem(image: UIImage(named: "icon_back-arrow"), style: .plain, target: self, action: #selector(backButtonPressed))
        leftBarButtons.append(backButton)
        navigationItem.setLeftBarButtonItems(leftBarButtons, animated: true)
        
        var rightBarButtons: [UIBarButtonItem] = [UIBarButtonItem]()
        let visitButton = UIBarButtonItem(image: UIImage(named: "icon_plane"), style: .plain, target: self, action: #selector(postVisit))
        rightBarButtons.append(visitButton)
        navigationItem.setRightBarButtonItems(rightBarButtons, animated: true)
    }
    
    // MARK: setUIActions - Set UI action buttons
    
    func setUIActions() {
        if (isLoadingNPSPlaces) {
            newPlacesButton?.isEnabled = false
            removePlacesButton?.isEnabled = false
        } else {
            newPlacesButton?.isEnabled = true
            removePlacesButton?.isEnabled = false
        }
    }
    
    // MARK: setUIForDownloadingPlaces - Set user interface for downloading places
    
    func setUIForDownloadingPlaces() {
        newPlacesButton?.isEnabled = false
        removePlacesButton?.isEnabled = false
        placeCollectionView.reloadData()
    }
    
    // MARK: resetUIAfterDownloadingPlaces - Reset user interface after download
    
    func resetUIAfterDownloadingPlaces() {
        newPlacesButton?.isEnabled = true
        removePlacesButton?.isEnabled = false
        placeCollectionView.reloadData()
    }
    
    // MAKR: displayError - Display error
    
    func displayError(_ errorString: String?) {
        
        print(errorString!)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: setSelectedPlace - set selected places from collection cell selection
    
    func setSelectedPlace(_ cell: PlaceCollectionCell, at indexPath: IndexPath) {
        
        // Set place cell selection
        if let index = selectedPlaceCells.index(of: indexPath) {
            selectedPlaceCells.remove(at: index)
        } else {
            selectedPlaceCells.append(indexPath)
        }
        
        toggleSelectedPlace(cell, at: indexPath)
    }
    
    // MARK: toggleSelectedPlace - toggle the selected place cell in collection view
    
    func toggleSelectedPlace(_ cell: PlaceCollectionCell, at indexPath: IndexPath) {
        
        // Toggle place selection
        if let _ = selectedPlaceCells.index(of: indexPath) {
            cell.alpha = 0.375
        } else {
            cell.alpha = 1.0
        }
    }
    
    // MARK: resetSelectedPlaceCells - reset the selected place cell array
    
    func resetSelectedPlaceCells() {
        
        // Reset selected cells
        selectedPlaceCells.removeAll()
        placeCollectionView.reloadData()
    }
    
}

