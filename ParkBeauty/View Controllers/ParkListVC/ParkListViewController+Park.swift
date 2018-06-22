//
//  ParkListViewController+Park.swift
//  ParkBeauty
//
//  Created by Shirley on 6/16/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import CoreData

// MARK: ParkListViewController+Park

extension ParkListViewController {
    
    func setUpFetchParkController() {
        
        let fetchRequest:NSFetchRequest<Park> = Park.fetchRequest()
        let sortDescriptor1 = NSSortDescriptor(key: "stateCode", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "fullName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        
        fetchedParkController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedParkController.delegate = self
        do {
            
            try fetchedParkController.performFetch()
            if let results = fetchedParkController?.fetchedObjects {
                
                self.parks = results
            }
        } catch {
            
            fatalError("The fetch parks could not be performed: \(error.localizedDescription)")
        }
    }
}
