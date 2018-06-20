//
//  VisitListViewController+Helper.swift
//  ParkBeauty
//
//  Created by Shirley on 6/17/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

// MARK: VisitListViewController+Helper

extension VisitListViewController {
    
    // MARK: createTopBarButtons - create and set the top bar buttons
    
    func createTopBarButtons(_ navigationItem: UINavigationItem) {
        
        var rightButtons: [UIBarButtonItem] = [UIBarButtonItem]()
        let addVisitButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addVisitPressed))
        rightButtons.append(addVisitButton)  // 1st button from the right
        navigationItem.setRightBarButtonItems(rightButtons, animated: true)
        
        var leftBarButtons: [UIBarButtonItem] = [UIBarButtonItem]()
        let backButton = UIBarButtonItem(image: UIImage(named: "icon_back-arrow"), style: .plain, target: self, action: #selector(backButtonPressed))
        leftBarButtons.append(backButton)
        navigationItem.setLeftBarButtonItems(leftBarButtons, animated: true)
    }
    
    // MARK: createBottomBarButton - create and set the bottom tool bar buttons
    
    func createBottomBarButton() {
        
        var toolbarButtons: [UIBarButtonItem] = [UIBarButtonItem]()
        
        // use empty flexible space bar button to center the remove places button
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let visitButton = UIBarButtonItem(image: UIImage(named: "icon_plane"), style: .plain, target: self, action: nil)
        toolbarButtons.append(flexButton)
        toolbarButtons.append(visitButton)
        toolbarButtons.append(flexButton)
        self.setToolbarItems(toolbarButtons, animated: true)
    }
    
    // MARK: getRatingStarImage - return star for rating
    
    func getRatingStarImage(starNumber: Int, forRating rating: Int16) -> UIImage {
        
        if rating >= starNumber {
            
            return starImage
        } else {
            
            return blankImage
        }
    }
}
