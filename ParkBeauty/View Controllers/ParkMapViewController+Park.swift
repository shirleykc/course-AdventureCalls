//
//  ParkMapViewController+Park.swift
//  ParkBeauty
//
//  Created by Admin on 6/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import MapKit
import CoreData

// MARK: ParkMapViewController+Park

extension ParkMapViewController {
    
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
    
//    // MARK: addLocationPin - add a location pin to data store
//
//    func addLocationPin(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> Pin {
//
//        let pin = Pin(context: dataController.viewContext)
//        pin.latitude = latitude
//        pin.longitude = longitude
//        pin.creationDate = Date()
//
//        try? dataController.viewContext.save()
//
//        return pin
//    }
    
    // MARK: createAnnotations - fetch parks from data store to create annotaions on map
    
    func createAnnotations() {
        
        // Create an MKPointAnnotation for each park
        guard let parks = fetchedParkController.fetchedObjects else {
            appDelegate.presentAlert(self, "No parks found")
            return
        }
        
        // first, remove previous annotations
        let allannotations = mapView.annotations
        mapView.removeAnnotations(allannotations)
        
        for aPark in parks {
            createAnnotation(park: aPark)
        }
    }
    
    // MARK: createAnnotation - create an annotation from park
    
    func createAnnotation(park: Park) {
        
        // create the annotation and set its coordiate properties
        let annotation = Annotation(park: park)
        
        // add annotation to the map
        mapView.addAnnotation(annotation)
    }
    
    // MARK: createAnnotationFor - create an annotation for a location coordinate
    
    func createAnnotationFor(coordinate: CLLocationCoordinate2D) -> Annotation {
        
        // create the annotation and set its coordiate properties
        let annotation = Annotation(locationCoordinate: coordinate)
        
        // add annotation to the map
        mapView.addAnnotation(annotation)
        
        return annotation
    }
}
