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
    
    // MARK: createRemoveParkBanner - create and set the remove park banner
    
    func createRemoveParkBanner() {
        
        var toolbarButtons: [UIBarButtonItem] = [UIBarButtonItem]()
        
        // use empty flexible space bar button to center the new collection button
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        removeParkBanner = UIBarButtonItem(title: "Tap Pins to Delete", style: .plain, target: self, action: nil)
        toolbarButtons.append(flexButton)
        toolbarButtons.append(removeParkBanner!)
        toolbarButtons.append(flexButton)
        self.setToolbarItems(toolbarButtons, animated: true)
    }
    
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
