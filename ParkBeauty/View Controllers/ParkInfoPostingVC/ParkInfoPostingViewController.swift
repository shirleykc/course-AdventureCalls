//
//  ParkInfoPostingViewController.swift
//  ParkBeauty
//
//  Created by Shirley on 6/3/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

// MARK: - ParkInfoPostingViewController: UIViewController

/**
 * This view controller demonstrates the objects involved in displaying park info
 * on a map and posting selected park info to core data.
 *
 * The map is a MKMapView.
 * The pins are represented by MKPointAnnotation instances.
 *
 * The view controller conforms to the MKMapViewDelegate so that it can receive a method
 * invocation when a pin annotation is tapped. It accomplishes this using two delegate
 * methods: one to put a small "info" button on the right side of each pin, and one to
 * respond when the "info" button is tapped.
 */

class ParkInfoPostingViewController: UIViewController {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var dataController: DataController!
    
    var parkCollection: [NPSPark]?
    var fetchedParks: [Park]!
    
    // action buttons
    var removeParkBanner: UIBarButtonItem?
    var saveButton: UIBarButtonItem?
    var cancelButton: UIBarButtonItem?
    
    var doDeletePark: Bool = false
    
//    var place: CLPlacemark?
//    var mediaURL: String?
    
    var fetchedParkController: NSFetchedResultsController<Park>!
//    var fetchedRegionController: NSFetchedResultsController<Region>!

    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Grab the app delegate */
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataController = appDelegate.dataController
        
        setUpFetchParkController()
        fetchedParks = fetchedParkController.fetchedObjects
        
        navigationController?.setToolbarHidden(true, animated: true)
//        navigationController?.toolbar.barTintColor = UIColor.red
//        navigationController?.toolbar.tintColor = UIColor.white
        
//        createRemoveParkBanner()
//        removeParkBanner?.isEnabled = true
        
        doDeletePark = true
        
        createTopBarButton(navigationItem)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.delegate = self
        
        if let parks = parkCollection,
            parks.count > 0 {
            
            // first, remove previous annotations
            
            let allannotations = mapView.annotations
            mapView.removeAnnotations(allannotations)
            
            for aPark in parks {
                
                // Here we create the annotation and set its park properties
                
                if let _ = aPark.latitude,
                    let _ = aPark.longitude {
                    
                    let annotation = Annotation(npsPark: aPark)

                    mapView.addAnnotation(annotation)
                }
            }
            if mapView.annotations.count > 1 {
                mapView.showAnnotations(mapView.annotations, animated: true)
            }            
        } else {
            appDelegate.presentAlert(self, "Unable to create annotation")
            return
        }
    }
    
    // MARK: Cancel Add Parks
    
    @objc func cancelAdd() {
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Add Parks

    @objc func addParks() {
        
        // Save parks from collection
        if let annotations = mapView.annotations as? [Annotation],
            annotations.count > 0 {
            
            for newPark in annotations {
                if let npsPark = newPark.npsPark {
                    
                    if fetchedParks.first(where: { $0.parkCode == npsPark.parkCode}) != nil {
                        print("Park \(npsPark.parkCode) exists in data store")
                        continue
                    } else {
                        print("Park \(npsPark.parkCode) not in data store")
                        let park = Park(context: self.dataController.viewContext)
                        park.creationDate = Date()
                        park.parkCode = npsPark.parkCode
                        park.stateCode = npsPark.states
                        if let latitude = npsPark.latitude,
                            let longtitude = npsPark.longitude {
                            park.latitude = latitude
                            park.longitude = longtitude
                        }
                        park.name = npsPark.fullName
                        park.url = npsPark.url
                        park.details = npsPark.description
                        park.fullName = npsPark.fullName
                    }
                }
            }
        
            try? self.dataController.viewContext.save()
        }

        self.navigationController?.setToolbarHidden(true, animated: true)
        
        doDeletePark = false
        
//        createEditButton(navigationItem)
        
        // go to next view
        completeInfoPosting()
    }

    // MARK: Complete info posting

    private func completeInfoPosting() {
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: MKMapViewDelegate

extension ParkInfoPostingViewController: MKMapViewDelegate {
    
    // MARK: mapView - Create a view with a right callout accessory view
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "park"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .purple
            pinView!.animatesDrop = true
            
            let deleteButton = UIButton(type: UIButtonType.custom) as UIButton
            deleteButton.frame.size.width = 44
            deleteButton.frame.size.height = 44
            deleteButton.backgroundColor = .yellow
            deleteButton.setImage(UIImage(named: "icon_trash"), for: .normal)
            
            pinView!.leftCalloutAccessoryView = deleteButton
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // MARK: mapView - calloutAccessoryControlTapped - delete the selected park from callout
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.leftCalloutAccessoryView {
            if let annotation = view.annotation as? Annotation {
                mapView.removeAnnotation(annotation)
            }
        }
    }

}
