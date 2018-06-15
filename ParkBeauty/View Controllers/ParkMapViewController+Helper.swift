//
//  ParkMapViewController+Helper.swift
//  ParkBeauty
//
//  Created by Admin on 6/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

// MARK: ParkMapViewController+Helper

extension ParkMapViewController {
    
    // MARK: createEditButton - create and set the Edit bar buttons
    
    func createEditButton(_ navigationItem: UINavigationItem) {
        
        var rightButtons: [UIBarButtonItem] = [UIBarButtonItem]()
        editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(editPark))
        rightButtons.append(editButton!)
        navigationItem.setRightBarButtonItems(rightButtons, animated: true)
    }
    
}

