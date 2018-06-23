//
//  PhotoAlbumViewController+Photo.swift
//  AdventureCalls
//
//  Created by Shirley on 6/19/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import CoreData

// MARK: PhotoAlbumViewController+Photo

extension PhotoAlbumViewController {
    
    // MARK: PhotoAlbumViewController - fetch photo data controller
    
    func setUpFetchedPhotoController(doRemoveAll: Bool) {
        
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "visit == %@", argumentArray: [visit!])
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedPhotoController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            
            try fetchedPhotoController.performFetch()
            if let results = fetchedPhotoController?.fetchedObjects {
                
                if doRemoveAll {
                    self.photos.removeAll()
                }
                self.photos = results
            }
        } catch {
            
            fatalError("The fetch photo could not be performed: \(error.localizedDescription)")
        }
    }
}
