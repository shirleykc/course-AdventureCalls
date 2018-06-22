//
//  ParkTabBarController.swift
//  ParkBeauty
//
//  Created by Shirley on 6/1/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ParkTabBarController: UITabBarController

/**
 * This tab bar controller manages the table view and map view of national parks.
 */

class ParkTabBarController: UITabBarController {
    
    // MARK: Properties
    
    var addpinButton: UIBarButtonItem?
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // create and set the bar buttons
        
        createTopBarButtons(navigationItem)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // create and set the bar buttons
        
        createTopBarButtons(navigationItem)
    }
    
    // MARK: Actions
    
    // MARK: Add Pin
    
    @objc func addpin() {
        
        // go to search park view
        
        let searchParkViewController = storyboard!.instantiateViewController(withIdentifier: "SearchParkViewController") as! SearchParkViewController
        
        navigationController!.pushViewController(searchParkViewController, animated: true)
    }
    
    // MARK: createTopBarButtons - create and set the bar buttons
    
    private func createTopBarButtons(_ navigationItem: UINavigationItem) {
        
        var rightButtons: [UIBarButtonItem] = [UIBarButtonItem]()
        addpinButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addpin))
        rightButtons.append(addpinButton!)  // 1st button from the right
        
        navigationItem.setRightBarButtonItems(rightButtons, animated: true)
    }
}
