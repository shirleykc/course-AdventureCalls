//
//  ParkListViewController+Park.swift
//  AdventureCalls
//
//  Created by Shirley on 6/16/18.
//  Copyright © 2018 Shirley Chan. All rights reserved.
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
 
        } catch {
            
            fatalError("The fetch parks could not be performed: \(error.localizedDescription)")
        }
    }
}
