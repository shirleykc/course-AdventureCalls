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
    var removeParkBanner: UIBarButtonItem?
    var editButton: UIBarButtonItem?
    var doneButton: UIBarButtonItem?
    
    var doDeletePark: Bool = false
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Life Cycle
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Grab the app delegate
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataController = appDelegate.dataController
        
        // Add gesture recognizer
        //        addGestureRecognizer()
        
        // Hide the toolbar
        self.navigationController?.setToolbarHidden(true, animated: true)
        
        // Create the Edit button on navigation bar
        createEditButton(navigationItem)
    }
    
    // MARK: viewAllAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        mapView.delegate = self
        
        // Grab the region
        setUpFetchRegionController()
        loadMapRegion()
        
        // Grab the pins
        setUpFetchParkController()
        createAnnotations()
        
        // Hide the toolbar
        self.navigationController?.setToolbarHidden(true, animated: true)
        
        // Create the Edit button on navigation bar
        createEditButton(navigationItem)
    }
    
    // MARK: viewDidDisappear
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        // reset
        fetchedParkController = nil
        fetchedRegionController = nil
        //       fetchedPhotosController = nil
    }
    
    // MARK: Actions
    
    // MARK: dropPin - drop a location pin on the map
    
    //    @objc func dropPin(_ recognizer: UIGestureRecognizer) {
    //
    //        let point:CGPoint = recognizer.location(in: self.mapView)
    //
    //        let coordinate = mapView.convert(point, toCoordinateFrom: self.mapView)
    //
    //        if (recognizer.state == .began) {
    //
    // //           annotation = createAnnotationFor(coordinate: coordinate)
    //
    //        } else if (recognizer.state == .changed) {
    //
    //            // move pin to a new location
    //            annotation?.updateCoordinate(newLocationCoordinate: coordinate)
    //
    //        } else if (recognizer.state == .ended) {
    //
    //            // Save location pin to data store
    //  //          let pin = addLocationPin(latitude: coordinate.latitude, longitude: coordinate.longitude)
    // //           annotation?.pin = pin
    //
    //            // Download photos for pin location
    //   //         searchPhotoCollectionFor(pin)
    //        }
    //    }
    
    // MARK: done - Done deleting pins
    
    @objc func done() {
        
        self.navigationController?.setToolbarHidden(true, animated: true)
        
        doDeletePark = false
        
        createEditButton(navigationItem)
    }
    
    // MARK: editPark - edit park pin button is pressed
    
    @objc func editPark() {
        
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.navigationController?.toolbar.barTintColor = UIColor.red
        self.navigationController?.toolbar.tintColor = UIColor.white
        
        createRemoveParkBanner()
        removeParkBanner?.isEnabled = true
        
        doDeletePark = true
        
        createDoneButton(navigationItem)
    }
    
    // MARK: addGestureRecognizer - configure tap and hold recognizer
    
    //    func addGestureRecognizer() {
    //        let longpressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(dropPin(_:)))
    //
    //        mapView.addGestureRecognizer(longpressRecognizer)
    //    }
}

// MARK: MKMapViewDelegate

extension ParkMapViewController: MKMapViewDelegate {
    
    // MARK: mapView - viewFor - Create a view with callout accessory view
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "park"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // MARK: mapView - didSelect - opens the photo album of the selected location pin
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if doDeletePark {
            if let annotation = view.annotation as? Annotation {
                //                if let pin = annotation.pin {
                //                    dataController.viewContext.delete(pin)
                //                    try? dataController.viewContext.save()
                //
                //                    mapView.removeAnnotation(annotation)
                //                    setUpFetchPinsController()
                //                }
            }
        } else {
            //           let controller = storyboard!.instantiateViewController(withIdentifier: "PhotoAlbumViewController") as! PhotoAlbumViewController
            if let annotation = view.annotation as? Annotation {
                
                //                controller.pin = annotation.pin
                //                controller.annotation = annotation
                //                controller.span = mapView.region.span
                //                controller.dataController = dataController
            }
            
            //           navigationController!.pushViewController(controller, animated: true)
        }
    }
    
    // MARK: mapView - regionDidChangeAnimated - Set and save location and zoom level when map region is changed
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        // Set and save location and zoom level when map region is changed
        //       setSpan()
    }
}

