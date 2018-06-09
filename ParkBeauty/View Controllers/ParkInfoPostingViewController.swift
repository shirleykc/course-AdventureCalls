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
    
    var fetchedParkController: NSFetchedResultsController<Park>!
    var fetchedRegionController: NSFetchedResultsController<Region>!
    
    var parkCollection: [NPSPark]?
//    var place: CLPlacemark?
//    var mediaURL: String?
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: BorderedButton!
//    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Grab the app delegate */
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        navigationItem.title = "Parks To Watch"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SAVE", style: .plain, target: self, action: #selector(addParks))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(cancelAdd))
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureUI()
        
        mapView.delegate = self
        
//        navigationItem.title = "Parks To Watch"
//        navigationItem.backBarButtonItem?.title = "CANCEL"
//        navigationItem.rightBarButtonItem?.title = "Save"
        
        if let parks = parkCollection,
            parks.count > 0 {
            
            // first, remove previous annotations
            let allannotations = mapView.annotations
            mapView.removeAnnotations(allannotations)
            
            for aPark in parks {
                
                if let latitude = aPark.latitude,
                    let longitude = aPark.longitude {

                    print("lat: \(latitude) long: \(longitude)")
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                    annotation.title = "\(aPark.fullName ?? "")"
    
                    mapView.addAnnotation(annotation)
    
                    // center the map on the latest park
//                        centerMapOnStudentLocation(location: placeLocation)
                }
            }
        }
    }
    
    // MARK: Finish - post student location using Parse API
    
    @IBAction func finishPressed(_ sender: AnyObject) {
        
//        setUIEnabled(false)
//
//        let studentParameters = buildJsonBodyParameters(student!)
//        activityIndicatorView.startAnimating()
//        UdacityClient.sharedInstance().postStudentLocation(studentParameters) { (success, results, errorString) in
//            performUIUpdatesOnMain {
//                self.activityIndicatorView.stopAnimating()
//                if success {
//                    self.completeInfoPosting()
//                } else {
//                    print(errorString!)
//                    self.appDelegate.presentAlert(self, "Unable to post student location, please try again")
//                }
//            }
//        }
    }
    
    // MARK: Cancel Add Parks
    
    @objc func cancelAdd() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Add Parks

    @objc func addParks() {
        // Save photo urls and title for pin
        if let newCollection = parkCollection {
            saveParksFrom(newCollection)
        }
 //       navigationController?.popViewController(animated: true)
    }
    
//    // MARK: JSON body parameters with student information
//
//    private func buildJsonBodyParameters(_ student: StudentInformation) -> [String:Any] {
//
//        /* TASK: Login, then get a session id */
//
//        /* 1. Set the jsonbody parameters */
//        let jsonBodyParameters = [
//            UdacityClient.JSONResponseKeys.UniqueKey: student.uniqueKey!,
//            UdacityClient.JSONResponseKeys.FirstName: student.firstName!,
//            UdacityClient.JSONResponseKeys.LastName: student.lastName!,
//            UdacityClient.JSONResponseKeys.MapString: student.mapString!,
//            UdacityClient.JSONResponseKeys.MediaURL: student.mediaURL!,
//            UdacityClient.JSONResponseKeys.Latitude: student.latitude!,
//            UdacityClient.JSONResponseKeys.Longitude: student.longitude!
//            ] as [String : Any]
//
//        return jsonBodyParameters
//    }
//
//    // MARK: Center map on latest student location
//
//    private func centerMapOnStudentLocation(location: CLLocation) {
//        let regionRadius: CLLocationDistance = 1000  // meters
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
//                                                                  regionRadius, regionRadius)
//        mapView.setRegion(coordinateRegion, animated: true)
//    }
//
//    // MARK: Complete info posting
//
//    private func completeInfoPosting() {
//        navigationController?.popToRootViewController(animated: true)
//    }
}

// MARK: MKMapViewDelegate

extension ParkInfoPostingViewController: MKMapViewDelegate {
    
    // MARK: mapView - Create a view with a right callout accessory view
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
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
    
    // MARK: mapView - opens the system browser to the URL specified in
    // the annotationViews subtitle property.
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
//            if let toOpen = view.annotation?.subtitle! {
//                appDelegate.validateURLString(toOpen) { (success, url, errorString) in
//                    performUIUpdatesOnMain {
//                        if success {
//                            UIApplication.shared.open(url!, options: [:]) { (success) in
//                                if !success {
//                                    self.appDelegate.presentAlert(self, "Cannot open URL \(url!)")
//                                }
//                            }
//                        } else {
//                            self.appDelegate.presentAlert(self, errorString)
//                        }
//                    }
//                }
//            }
        }
    }
}

// MARK: - ParkInfoPostingViewController (Configure UI)

extension ParkInfoPostingViewController {
    
    // MARK: Enable or disable UI
    
    func setUIEnabled(_ enabled: Bool) {
//        finishButton.isEnabled = enabled
//
//        // adjust finish button alpha
//        if enabled {
//            finishButton.alpha = 1.0
//        } else {
//            finishButton.alpha = 0.5
//        }
    }
    
    // MARK: Configure UI
    
    func configureUI() {
//        activityIndicatorView.stopAnimating()
        setUIEnabled(true)
    }
}

extension ParkInfoPostingViewController {
    
    // MARK: setUpFetchParkController - fetch parks data controller
    
    func setUpFetchParkController() {
        
        let fetchRequest: NSFetchRequest<Park> = Park.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedParkController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedParkController.performFetch()
        } catch {
            fatalError("The fetch parks could not be performed: \(error.localizedDescription)")
        }
    }
    
    func saveParksFrom(_ newCollection: [NPSPark]) {
        
        // Save park info
        for newPark in newCollection {
            let park = Park(context: self.dataController.viewContext)
            park.creationDate = Date()
            if let latitude = newPark.latitude,
                let longitude = newPark.longitude {
                park.latitude = latitude
                park.longitude = longitude
            }
            park.name = newPark.fullName
            park.parkCode = newPark.parkCode
            park.stateCode = newPark.states
            park.url = newPark.url
            park.details = newPark.description
        }
        
        try? self.dataController.viewContext.save()
    }
}

