//
//  ParkMapViewController.swift
//  ParkBeauty
//
//  Created by Shirley on 6/1/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

import Foundation
import UIKit
import MapKit
import CoreData

// MARK: - ParkMapViewController : UIViewController, MKMapViewDelegate

/**
 * This view controller demonstrates the objects involved in displaying pins on a map.
 *
 * The map is a MKMapView.
 * The pins are represented by MKPointAnnotation instances.
 *
 * The view controller conforms to the MKMapViewDelegate.
 */

class ParkMapViewController : UIViewController {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var completionHandlerForOpenURL: ((_ success: Bool) -> Void)?
    
    var dataController: DataController!
    
    var fetchedParkController: NSFetchedResultsController<Park>!
    var fetchedRegionController: NSFetchedResultsController<Region>!
    //    var fetchedPhotosController: NSFetchedResultsController<Photo>!
    
    var annotation: Annotation?
    var region: Region?
    
    // action buttons
//    var removeParkBanner: UIBarButtonItem?
//    var editButton: UIBarButtonItem?
//    var doneButton: UIBarButtonItem?
    
//    var doDeletePark: Bool = false
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Life Cycle
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Grab the app delegate
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataController = appDelegate.dataController
        
        // Hide the toolbar
        
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    // MARK: viewAllAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        mapView.delegate = self
        
        // Grab the region
        
        setUpFetchRegionController()
        loadMapRegion()
        
        // Grab the parks
        
        setUpFetchParkController()
        createAnnotations()
        
        // Hide the toolbar
        
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    // MARK: viewDidDisappear
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        // reset
        
        fetchedParkController = nil
        fetchedRegionController = nil
    }
    
    // MARK: Actions
    
}

// MARK: MKMapViewDelegate

extension ParkMapViewController: MKMapViewDelegate {
    
    // MARK: mapView - viewFor - Create a view with callout accessory view
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "park"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // MARK: mapView - calloutAccessoryControlTapped - opens the places of the selected park
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            
            if let annotation = view.annotation as? Annotation {
                
                let controller = storyboard!.instantiateViewController(withIdentifier: "PlaceCollectionViewController") as! PlaceCollectionViewController

                controller.park = annotation.park
                controller.annotation = annotation
                controller.span = mapView.region.span
                controller.dataController = dataController
                
                navigationController!.pushViewController(controller, animated: true)
                
            } else {
                
                self.appDelegate.presentAlert(self, "Cannot load park details")
                
            }
        }
    }
    
    // MARK: mapView - regionDidChangeAnimated - Set and save location and zoom level when map region is changed
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        // Set and save location and zoom level when map region is changed
        
        setSpan()
    }
}
