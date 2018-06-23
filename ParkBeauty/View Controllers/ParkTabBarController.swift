//
//  ParkTabBarController.swift
//  ParkBeauty
//
//  Created by Shirley on 6/1/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import CoreData
import UIKit

// MARK: - ParkTabBarController: UITabBarController

/**
 * This tab bar controller manages the table view and map view of national parks.
 */

class ParkTabBarController: UITabBarController {
    
    // MARK: Properties
    var appDelegate: AppDelegate!
    var dataController: DataController!
    
    var fetchedParkController: NSFetchedResultsController<Park>!
    
    var addpinButton: UIBarButtonItem?
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Grab the app delegate
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataController = appDelegate.dataController
        
        // create and set the bar buttons
        
        createTopBarButtons(navigationItem)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Grab the parks
        
        setUpFetchParkController()

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

// MARK: ParkTabBarController+Park

extension ParkTabBarController {
    
    // MARK: setUpFetchParkController - fetch parks data controller
    
    func setUpFetchParkController() {
        
        let fetchRequest: NSFetchRequest<Park> = Park.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedParkController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            
            try fetchedParkController.performFetch()
        } catch {
            
            fatalError("The fetch pins could not be performed: \(error.localizedDescription)")
        }
    }
}
