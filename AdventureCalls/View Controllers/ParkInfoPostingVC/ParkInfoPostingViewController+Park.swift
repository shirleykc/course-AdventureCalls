//
//  ParkInfoPostingViewController+Park.swift
//  AdventureCalls
//
//  Created by Shirley on 6/15/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import MapKit
import CoreData

// MARK: ParkInfoPostingViewController+Park

extension ParkInfoPostingViewController {
    
    // MARK: setUpFetchParkController - fetch parks data controller
    
    func setUpFetchParkController() {
        
        let fetchRequest: NSFetchRequest<Park> = Park.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedParkController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            
            try fetchedParkController.performFetch()
        } catch {
            
            fatalError("The fetch park could not be performed: \(error.localizedDescription)")
        }
    }
}
