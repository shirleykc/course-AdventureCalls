//
//  VisitInfoPostingViewController+Visit.swift
//  ParkBeauty
//
//  Created by Shirley on 6/17/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import CoreData

// MARK: VisitInfoPostingViewController+Visit

extension VisitInfoPostingViewController {
    
    // MARK: setupFetchedVisitController - fetch visits for park
    
    func setupFetchedVisitController() {
        
        let fetchRequest:NSFetchRequest<Visit> = Visit.fetchRequest()
        let predicate = NSPredicate(format: "park == %@", argumentArray: [park!])
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = []
        
        fetchedVisitController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            
            try fetchedVisitController.performFetch()
        } catch {
            
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
}
