//
//  PlaceCollectionViewController+Place.swift
//  ParkBeauty
//
//  Created by Shirley on 6/8/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import CoreData

// MARK: PlaceCollectionViewController+Place

extension PlaceCollectionViewController {
    
    // MARK: setupFetchedPlaceController - fetch the places for the park in data store
    
    func setupFetchedPlaceController(doRemoveAll: Bool) {
        
        let fetchRequest:NSFetchRequest<Place> = Place.fetchRequest()
        let predicate = NSPredicate(format: "park == %@", argumentArray: [park!])
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = []
        
        fetchedPlaceController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedPlaceController.performFetch()
            if let results = fetchedPlaceController?.fetchedObjects {
                
                if doRemoveAll {
                    self.places.removeAll()
                }
                self.places = results
            }
        } catch {
            
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    // MARK: savePlacesFor - add places to the park's places array in data store
    
    func savePlacesFor(_ park: Park, from newCollection: [NPSPlace], completionHandlerForPlaceSave: @escaping (_ success: Bool) -> Void) {
        
        // Save place urls and titles for park
        for newPlace in newCollection {
            
            if let imageUrl = newPlace.imageUrl {
                
                let place = Place(context: self.dataController.viewContext)
                place.creationDate = Date()
                place.title = newPlace.title
                place.details = newPlace.description
                place.url = newPlace.placeUrl
                
                if let latitude = newPlace.latitude,
                    let longitude = newPlace.longitude {
                    place.latitude = latitude
                    place.longitude = longitude
                }
                
                place.imageUrl = imageUrl
                place.imageAltText = newPlace.imageAltText
                place.image = Data()
                place.park = park
            }
        }
        
        try? self.dataController.viewContext.save()
        
        completionHandlerForPlaceSave(true)
    }
    
    // MARK: savePlaceImageFor - save place images for the park in data store
    
    func savePlaceImageFor(_ park: Park, completionHandlerForPlaceImageSave: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        setupFetchedPlaceController(doRemoveAll: false)
        if self.places.count > 0 {
            
            for aPlace in self.places {
                
                if let imageUrl = aPlace.imageUrl {
                    
                    NPSClient.sharedInstance().getPlaceImageFrom(imageUrl) { (imageData, error) in
                        
                        if error == nil {
                            
                            performUIUpdatesOnMain {
                                
                                aPlace.image = imageData
                                try? self.dataController.viewContext.save()
                            }
                        }
                    }
                }
            }
        }
        completionHandlerForPlaceImageSave(true, nil)
    }
    
    // MARK: deleteAllPlaces - Delete all places for the park from data store
    
    func deleteAllPlaces() {
        
        for aPlace in self.places {
            
            dataController.viewContext.delete(aPlace)
        }
        
        try? dataController.viewContext.save()
        
        // Reset
        
        self.places.removeAll()
    }
    
    // MARK: searchPlaceCollectionFor - search NPS place collection for park
    
    func searchPlaceCollectionFor(_ park: Park, _ start: Int?, completionHandlerForSearchPlaceCollection: @escaping (_ success: Bool, _ result: [NPSPlace]?, _ error: String?) -> Void) {
        
        NPSClient.sharedInstance().getPlacesFor(park.parkCode, start) { (results, start, error) in
            
            guard (error == nil) else {
                
                completionHandlerForSearchPlaceCollection(false, nil, (error?.userInfo[NSLocalizedDescriptionKey] as! String))
                return
            }
            
            performUIUpdatesOnMain {
                
                if let results = results {
                    
                    completionHandlerForSearchPlaceCollection(true, results, nil)
                } else {
                    
                    completionHandlerForSearchPlaceCollection(false, nil, "Cannot load places")
                }
            }
        }
    }
    
    // MARK: downloadNPSPlacesFor - download new NPS place collection
    
    func downloadNPSPlacesFor(_ park: Park) {
        
        // Initialize
        PlaceCollectionViewController.hasNPSPlace = true
        
        searchPlaceCollectionFor(park, NPSClient.startRecord) { (success, result, error) in
            
            if success {
                
                self.savePlacesFor(park, from: result!) { (success) in
                    if success {
                        
                        self.savePlaceImageFor(park) { (success, error) in
                            if success {
                                
                                self.displayPlaces { (completion) in
                                    self.resetUIAfterDownloadingPlaces()
                                }
                            }
                            else {
                                
                                self.displayError("Unable to save place images")
                            }
                        }
                    } else {
                        
                        self.displayError("Unable to save place")
                    }
                }
            } else {
                
                self.displayError(error)
            }
            self.isLoadingNPSPlaces = false
        }
        self.resetUIAfterDownloadingPlaces()
    }
    
    // MARK: displayPlaces - dipplay places in collection view
    
    func displayPlaces(completionHandlerForDisplayPlaces: @escaping (_ success: Bool) -> Void) {
        
        self.isLoadingNPSPlaces = false
        self.setupFetchedPlaceController(doRemoveAll: true)
        
        // Display new set of places for the park
        if (self.places.count > 0) {
            
            let delay = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: delay) {
                
                completionHandlerForDisplayPlaces(true)
            }
        } else {
            
            self.appDelegate.presentAlert(self, "No places available")
            completionHandlerForDisplayPlaces(true)
        }
    }
}
