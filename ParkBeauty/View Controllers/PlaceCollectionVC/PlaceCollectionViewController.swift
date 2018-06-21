//
//  PlaceCollectionViewController.swift
//  ParkBeauty
//
//  Created by Shirley on 6/6/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

// MARK: PlaceCollectionViewController

class PlaceCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var annotation: Annotation!
    var span: MKCoordinateSpan!
    
    // action buttons
//    var newPlacesButton: UIBarButtonItem?
//    var removePlacesButton: UIBarButtonItem?
    
    // The park whose places are being displayed
    var park: Park!
    var places = [Place]()
    var placeCollection: [NPSPlace]!
    
    var dataController:DataController!
    var fetchedPlaceController:NSFetchedResultsController<Place>!
    
    var selectedPlaceCells = [IndexPath]()
    
    var isLoadingNPSPlaces: Bool = false
    var isLabelExpanded: Bool = false
    
    static var hasNPSPlace: Bool = false
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var parkDescriptionLabel: UILabel!
    @IBOutlet weak var parkDescriptionLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var placeCollectionView: UICollectionView!
    
    // MARK: Life Cycle
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Grab the app delegate
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
//        dataController = appDelegate.dataController
        
        self.navigationController?.setToolbarHidden(false, animated: true)
//        self.navigationController?.toolbar.barTintColor = UIColor.white
//        self.navigationController?.toolbar.tintColor = UIColor.blue
        
//        createTopBarButtons()
        
        // Set title to park name        
        if let name = park.fullName {
            self.title = name
        } else {
            self.title = "National Park Places"
        }
        
        placeCollectionView.delegate = self
        
        mapView.delegate = self
        
        // add annotation to the map
        
        mapView.addAnnotation(annotation)
        
        // center the map on the park location
        
        let location = CLLocation(latitude: park.latitude, longitude: park.longitude)
        centerMapOnParkLocation(location: location)
        
        addGestureRecognizer()
        
        print("park details: \(park.details)")
        if let description = park.details {
            parkDescriptionLabel.text = description
        } else {
            parkDescriptionLabel.text = ""
        }
        parkDescriptionLabel.numberOfLines = AppDelegate.AppConstants.MaxNumberOfLines
        parkDescriptionLabel.lineBreakMode = .byTruncatingTail
        isLabelExpanded = false
        
        // Grab the places
        
        setupFetchedPlaceController(doRemoveAll: false)
        
        isLoadingNPSPlaces = (places.count == 0) ? true : false
        
        // Implement flowLayout here.
        
        let placeFlowLayout = placeCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        configure(flowLayout: placeFlowLayout!, withSpace: 1, withColumns: 3, withRows: 3)
        
        // Initialize new collection button
        
//        createNewPlacesButton()
//        setUIActions()
        
        // If empty places collection, then download new set of places
        
        if (isLoadingNPSPlaces) {
            
            setUIForDownloadingPlaces()
            downloadNPSPlacesFor(park)
        } else {
            
 //           newPlacesButton?.isEnabled = true
        }
    }
    
    // MARK: viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        parkDescriptionLabel.numberOfLines = AppDelegate.AppConstants.MaxNumberOfLines
        parkDescriptionLabel.lineBreakMode = .byTruncatingTail
        isLabelExpanded = false
        
        // Grab the places
        setupFetchedPlaceController(doRemoveAll: false)
        
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        placeCollectionView.reloadData()
    }
    
    // MARK: viewDidAppear
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.navigationController?.setToolbarHidden(false, animated: true)

        placeCollectionView.reloadData()
    }
    
    // MARK: viewDidDisappear
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        fetchedPlaceController = nil
        
//        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    // MARK: Actions
    
    // MARK: infoButtonPressed - info button to launch NPS official site
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        print("infoButtonPressed")
        guard let urlString = park.url else {
            
            appDelegate.presentAlert(self, "Invalid URL")
            return
        }
        
        appDelegate.validateURLString(urlString) { (success, url, errorString) in
            performUIUpdatesOnMain {
                
                if success {
                    
                    UIApplication.shared.open(url!, options: [:]) { (success) in
                        if !success {
                            
                            self.appDelegate.presentAlert(self, "Cannot open URL")
                        }
                    }
                } else {
                    
                    self.appDelegate.presentAlert(self, errorString)
                }
            }
        }
    }
    
    // MARK: handleTapLabel - tap label to toggle expand or collapse text
    
    @objc func handleTapLabel(_ sender: UITapGestureRecognizer) {
        
        if let label = sender.view as? UILabel {
            
            if isLabelExpanded {
                
                // collapse text
                
                label.numberOfLines = AppDelegate.AppConstants.MaxNumberOfLines
                label.lineBreakMode = .byTruncatingTail
                isLabelExpanded = false
            } else {
                
                // expand text
                
                label.numberOfLines = 0
                label.lineBreakMode = .byWordWrapping
                isLabelExpanded = true
            }
            
            UIView.animate(withDuration: 0.5) {
                
                label.superview?.layoutIfNeeded()
            }
        }
    }
    
    // MARK: newCollectionPressed - new collection button is pressed
    
//    @objc func newCollectionPressed() {
//
//        // Initialize
//        isLoadingNPSPlaces = true
//
//        setUIForDownloadingPlaces()
////        deleteAllPlaces()
//
////        downloadNPSPlacesFor(park)
//    }
    
    // MARK: removePlacesPressed - remove selected places button is pressed
    
//    @objc func removePlacesPressed(_ sender: UIButton?) {
//
//        var selectedPlaces = [Place]()
//        selectedPlaceCells = selectedPlaceCells.sorted(by: {$0.item > $1.item})
//
//        // Delete selected places and perform batch update
//        placeCollectionView.performBatchUpdates({
//
//            // Delete places from collectioView and collection
//            for indexPath in self.selectedPlaceCells {
//                self.placeCollectionView.deleteItems(at: [indexPath])
//                self.places.remove(at: indexPath.item)
//            }
//
//            // Delete places from data store
//            for indexPath in self.selectedPlaceCells {
//                let aPlace = fetchedPlaceController.object(at: indexPath)
//                selectedPlaces.append(aPlace)
//            }
//
//            performUIUpdatesOnMain {
//                for aPlace in selectedPlaces {
//                    self.dataController.viewContext.delete(aPlace)
//                }
//
//                try? self.dataController.viewContext.save()
//            }
//        }) {(completion) in
//
//            // Fetch remaining photos from the data store
//            self.setupFetchedPlaceController(doRemoveAll: true)
//
//            // Reset
//            self.removePlacesButton?.isEnabled = false
//            self.createNewPlacesButton()
//            self.newPlacesButton?.isEnabled = true
//            self.resetSelectedPlaceCells()
//        }
//    }
    
    // MARK: backButtonPressed - back button is pressed
    
    @IBAction func backButtonPressed() {
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: homeButtonPressed - back button is pressed
    
    @IBAction func homeButtonPressed() {
        
        navigationController?.popToRootViewController(animated: true) 
    }
    
    // MARK: postVisit - post visit button is pressed
    
    @IBAction func postVisit() {
        
        print("postVisit")
        
//        setUIEnabled(true)
        
        // go to next view
        let controller = storyboard!.instantiateViewController(withIdentifier: "VisitListViewController") as! VisitListViewController
        controller.park = park
        controller.dataController = dataController
        navigationController!.pushViewController(controller, animated: true)
    }
    
    // MARK: addGestureRecognizer - configure tap and hold recognizer
    
    func addGestureRecognizer() {
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapLabel(_:)))
        
        parkDescriptionLabel.isUserInteractionEnabled = true
        parkDescriptionLabel.addGestureRecognizer(tapRecognizer)
    }

    // MARK: configure - configure the places collection view flowLayout
    
    func configure(flowLayout: UICollectionViewFlowLayout, withSpace space: CGFloat, withColumns numOfColumns: CGFloat, withRows numOfRows: CGFloat) {
        
        let width: CGFloat = (UIScreen.main.bounds.size.width - ((numOfColumns + 1) * space)) / numOfColumns
        let height: CGFloat = (placeCollectionView.frame.size.height - ((numOfRows + 1) * space)) / numOfRows
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    // MARK: Center map on park location
    
    func centerMapOnParkLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = AppDelegate.AppConstants.RegionRadius  
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

// MARK: MKMapViewDelegate

extension PlaceCollectionViewController: MKMapViewDelegate {
    
    // MARK: mapView - viewFor - Create a view for the annotation
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "park"
        
        var placeView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if placeView == nil {
            
            placeView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            // callout to show park name
            
            placeView!.canShowCallout = true
            placeView!.pinTintColor = .red
        }
        else {
            
            placeView!.annotation = annotation
        }
        
        return placeView
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource

extension PlaceCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: numberOfSections - collectionView - Collection View Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return fetchedPlaceController.sections?.count ?? 1
    }
    
    // MARK: collectionView - numberOfItemsInSection - Collection View Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Set number of photos to display
        var placeCount: Int
        if (isLoadingNPSPlaces) {
            
            placeCount = Int(NPSClient.ParameterValues.PerPage)!
        } else {
            
            placeCount = places.count
        }
        
        return placeCount
    }
    
    // MARK: collectionView - cellForItemAt - Collection View Cell Item
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceCollectionCell", for: indexPath) as! PlaceCollectionCell
        
        // Initialize
        
        cell.placeImage?.image = UIImage()
        
        if (PlaceCollectionViewController.hasNPSPlace) {
            
            cell.activityIndicatorView.startAnimating()
        }
        
        // Display photo
        if (!isLoadingNPSPlaces) {
            
            if indexPath.item < places.count {
                
                let aPlace = fetchedPlaceController.object(at: indexPath)
                if let imageData = aPlace.image {
                    
                    cell.placeImage?.image = UIImage(data: imageData)
                    if let title = aPlace.title {
                        cell.title?.text = "\(title)"
                    } else {
                        cell.title?.text = ""
                    }
                    cell.activityIndicatorView.stopAnimating()
                }
            }
        }
        
 //       toggleSelectedPlace(cell, at: indexPath)
        
        return cell
    }
    
    // MARK: collectionView - didSelectItemAt - Select an item in Collection View
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
//        
//        // Add or remove the highlighted cells to the list
//        let cell = collectionView.cellForItem(at: indexPath) as! PlaceCollectionCell
//        
//        setSelectedPlace(cell, at: indexPath)
//        
//        // create and set action button
//        if selectedPlaceCells.count > 0 {
//            
//            newPlacesButton?.isEnabled = false
//            createRemovePlacesButton()
//            removePlacesButton?.isEnabled = true
//        } else {
//            
//            removePlacesButton?.isEnabled = false
//            createNewPlacesButton()
//            newPlacesButton?.isEnabled = true
//        }
//    }
}
