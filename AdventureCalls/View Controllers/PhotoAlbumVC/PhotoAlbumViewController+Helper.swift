//
//  PhotoAlbumViewController+Helper.swift
//  AdventureCalls
//
//  Created by Shirley on 6/20/18.
//  Copyright © 2018 Shirley Chan. All rights reserved.
//

import UIKit

// MARK: - PhotoAlbumViewController+Helper (Configure UI)

extension PhotoAlbumViewController {
    
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

