//
//  PlaceCollectionViewController+Helper.swift
//  ParkBeauty
//
//  Created by Shirley on 6/8/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

// MARK: - PlaceCollectionViewController+Helper (Configure UI)

extension PlaceCollectionViewController {
    
    // MARK: setUIForDownloadingPlaces - Set user interface for downloading places
    
    func setUIForDownloadingPlaces() {
        
        placeCollectionView.reloadData()
    }
    
    // MARK: resetUIAfterDownloadingPlaces - Reset user interface after download
    
    func resetUIAfterDownloadingPlaces() {
        
        placeCollectionView.reloadData()
    }
    
    // MAKR: displayError - Display error
    
    func displayError(_ errorString: String?) {

        print(errorString!)
        dismiss(animated: true, completion: nil)
    }
}
