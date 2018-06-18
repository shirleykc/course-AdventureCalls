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
    
    // MARK: createBarButtons - create and set the bar buttons
    
    func createBarButtons(_ navigationItem: UINavigationItem) {
        
        var rightButtons: [UIBarButtonItem] = [UIBarButtonItem]()
        let addVisitButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addVisitPressed))
        rightButtons.append(addVisitButton)  // 1st button from the right
        navigationItem.setRightBarButtonItems(rightButtons, animated: true)
        
        var leftBarButtons: [UIBarButtonItem] = [UIBarButtonItem]()
        let backButton = UIBarButtonItem(image: UIImage(named: "icon_back-arrow"), style: .plain, target: self, action: #selector(backButtonPressed))
        leftBarButtons.append(backButton)
        navigationItem.setLeftBarButtonItems(leftBarButtons, animated: true)
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
