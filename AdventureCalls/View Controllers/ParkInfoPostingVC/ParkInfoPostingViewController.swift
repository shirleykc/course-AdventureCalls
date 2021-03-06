//
//  ParkInfoPostingViewController.swift
//  AdventureCalls
//
//  Created by Shirley on 6/3/18.
//  Copyright © 2018 Shirley Chan. All rights reserved.
//

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
    var saveButton: UIBarButtonItem?
    var cancelButton: UIBarButtonItem?
    
    var fetchedParkController: NSFetchedResultsController<Park>!

    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: Life Cycle
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /* Grab the app delegate */
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataController = appDelegate.dataController
        
        activityIndicatorView.stopAnimating()
        
        setUpFetchParkController()
        fetchedParks = fetchedParkController.fetchedObjects
        
        navigationController?.setToolbarHidden(true, animated: true)
               
        createTopBarButton(navigationItem)
    }
    
    // MARK: viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        activityIndicatorView.stopAnimating()
        
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
                let currentMapRect = mapView.visibleMapRect
                let padding = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
                mapView.setVisibleMapRect(currentMapRect, edgePadding: padding, animated: true)
            }
        } else {
            
            appDelegate.presentAlert(self, "Unable to create annotation")
        }
    }
    
    // MARK: viewDidDisappear
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        // reset
        
        fetchedParkController = nil
    }
    
    // MARK: Actions
    
    // MARK: cancelAdd - Cancel Add Parks
    
    @objc func cancelAdd() {
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: addParksFrom - Add Parks from annotations

    fileprivate func addParksFrom(_ annotations: [Annotation], completionHandlerForParksSave: @escaping (_ success: Bool) -> Void) {
    
        for newPark in annotations {
            
            if let npsPark = newPark.npsPark {
                
                if fetchedParks.first(where: { $0.parkCode == npsPark.parkCode}) != nil {
                    
                    NSLog("Park \(npsPark.parkCode) exists in data store")
                    continue
                } else {
                    
                    let park = Park(context: self.dataController.viewContext)
                    park.creationDate = Date()
                    park.parkCode = npsPark.parkCode
                    park.stateCode = npsPark.states
                    park.name = npsPark.name
                    park.url = npsPark.url
                    park.details = npsPark.description
                    park.fullName = npsPark.fullName
                    
                    if let latitude = npsPark.latitude,
                        let longtitude = npsPark.longitude {
                        
                        park.latitude = latitude
                        park.longitude = longtitude
                    }
                }
            }
        }
        
        try? self.dataController.viewContext.save()
    
        completionHandlerForParksSave(true)
    }
    
    // MARK: completeInfoPosting - allow time to populate park list
    
    func completeSaveParks(completionHandlerForSaveParks: @escaping (_ success: Bool) -> Void) {
        
        let delay = DispatchTime.now() + .seconds(5)
        DispatchQueue.main.asyncAfter(deadline: delay) {
            
            self.setUpFetchParkController()
            
            completionHandlerForSaveParks(true)
        }
    }
    
    @objc func addParks() {
        
        // Save parks from collection
        
        if let annotations = mapView.annotations as? [Annotation],
            annotations.count > 0 {
            
            activityIndicatorView.startAnimating()
            self.addParksFrom(annotations) { (success) in
                
                if success {
                    
                    self.completeSaveParks { (success) in
                        self.activityIndicatorView.stopAnimating()
                        self.navigationController?.setToolbarHidden(true, animated: true)
                        
                        // go to next view
                        
                        self.completeInfoPosting()
                    }
                }
            }
        } else {
            self.activityIndicatorView.stopAnimating()
            self.navigationController?.setToolbarHidden(true, animated: true)
            
            // go to next view
            
            self.completeInfoPosting()
        }
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
            deleteButton.frame.size.width = AppDelegate.AppConstants.ButtonFrameWidth
            deleteButton.frame.size.height = AppDelegate.AppConstants.ButtonFrameHeight
            deleteButton.backgroundColor = .yellow
            deleteButton.setImage(UIImage(named: "icon_trash"), for: .normal)
            
            pinView!.leftCalloutAccessoryView = deleteButton
        }
        else {
            
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // MARK: mapView - calloutAccessoryControlTapped - delete the selected park from left callout
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.leftCalloutAccessoryView {
            
            if let annotation = view.annotation as? Annotation {
                
                mapView.removeAnnotation(annotation)
            }
        }
    }
}
