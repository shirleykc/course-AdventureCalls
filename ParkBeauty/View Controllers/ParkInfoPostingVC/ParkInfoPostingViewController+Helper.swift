//
//  ParkInfoPostingViewController+Helper.swift
//  ParkBeauty
//
//  Created by Admin on 6/14/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

// MARK: ParkInfoPostingViewController+Helper

extension ParkInfoPostingViewController {
    
    // MARK: createDoneButton - create and set the Done bar buttons
    
    func createTopBarButton(_ navigationItem: UINavigationItem) {
        
        navigationItem.title = "Parks To Watch"
        
        var rightButtons: [UIBarButtonItem] = [UIBarButtonItem]()
        saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(addParks))
        rightButtons.append(saveButton!)
        navigationItem.setRightBarButtonItems(rightButtons, animated: true)
        
        var leftButtons: [UIBarButtonItem] = [UIBarButtonItem]()
        cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancelAdd))
        leftButtons.append(cancelButton!)
        navigationItem.setLeftBarButtonItems(leftButtons, animated: true)
    }
}
