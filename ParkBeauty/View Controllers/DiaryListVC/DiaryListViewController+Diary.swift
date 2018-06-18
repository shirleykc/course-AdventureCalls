//
//  DiaryListViewController+Diary.swift
//  ParkBeauty
//
//  Created by Shirley on 6/14/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import CoreData

// MARK: DiaryListViewController+Region

extension DiaryListViewController {
    
    // MARK: DiaryListViewController - fetch diary data controller
    
    func setUpFetchDiaryController() {
        
        let fetchRequest: NSFetchRequest<Diary> = Diary.fetchRequest()
        let predicate = NSPredicate(format: "visit == %@", argumentArray: [visit!])
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedDiaryController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            
            try fetchedDiaryController.performFetch()
        } catch {
            
            fatalError("The fetch region could not be performed: \(error.localizedDescription)")
        }
    }
}
