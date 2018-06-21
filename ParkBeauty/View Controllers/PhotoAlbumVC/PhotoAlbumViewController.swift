//
//  PhotoAlbumViewController.swift
//  ParkBeauty
//
//  Created by Shirley on 6/12/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import CoreData

// MARK: PhotoAlbumViewController

class PhotoAlbumViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    
    // action buttons
//    var newPlacesButton: UIBarButtonItem?
    var removePhotosButton: UIBarButtonItem?
    
    // The park visit whose photos are being displayed
    var park: Park!
    var visit: Visit!
    var photos = [Photo]()
 //   var photoCollection: [NPSPlace]!
    
    var dataController:DataController!
    var fetchedPhotoController:NSFetchedResultsController<Photo>!
    
    var selectedPhotoCells = [IndexPath]()
    
    var isLoadingPhotos: Bool = false
//    var isLabelExpanded: Bool = false
    
    static var hasPhotos: Bool = false
    
    // A date formatter for date text
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    // MARK: Outlets
    
    @IBOutlet weak var parkCodeLabel: UILabel!
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    // MARK: Life Cycle
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Grab the app delegate
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        //        dataController = appDelegate.dataController
        
        // Set title to travel date
        
        if let travelDate = visit.travelDate {
            self.title = "Visit Photos \(dateFormatter.string(from: travelDate))"
        } else if let name = park.fullName {
            self.title = "\(name) Visit Photos"
        } else {
            self.title = "National Park Visit Photos"
        }
        
        if let parkCode = park.parkCode {
            parkCodeLabel?.text = parkCode.uppercased()
        } else {
            parkCodeLabel?.text = ""
        }
        
        if let parkName = park.fullName {
            parkNameLabel?.text = parkName
        } else {
            parkNameLabel?.text = ""
        }
        
        self.navigationController?.setToolbarHidden(false, animated: true)
        
//        createTopBarButtons()
        
        photoCollectionView.delegate = self
        
        addGestureRecognizer()
        
        // Grab the photos
        
        setUpFetchedPhotoController(doRemoveAll: false)
        
        isLoadingPhotos = (photos.count == 0) ? true : false
        
        // Implement flowLayout here.
        
        let photoFlowLayout = photoCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        configure(flowLayout: photoFlowLayout!, withSpace: 1, withColumns: 3, withRows: 3)
        
        // Initialize new collection button
        
//        createNewPlacesButton()
//        setUIActions()
        
        // If empty places collection, then download new set of places
        
//        if (isLoadingNPSPlaces) {
//
//            setUIForDownloadingPlaces()
//            downloadNPSPlacesFor(park)
//        } else {
//
//            newPlacesButton?.isEnabled = true
//        }
    }
    
    // MARK: viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Grab the places
        setUpFetchedPhotoController(doRemoveAll: false)
        
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        photoCollectionView.reloadData()
    }
    
    // MARK: viewDidAppear
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        photoCollectionView.reloadData()
    }
    
    // MARK: viewDidDisappear
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        fetchedPhotoController = nil
        
//        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    // MARK: Actions
    
    // MARK: backButtonPressed - back button is pressed
    
    @IBAction func backButtonPressed() {
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: homeButtonPressed - home button is pressed
    
    @IBAction func homeButtonPressed() {
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: diaryButtonPressed - diary button is pressed
    
    @IBAction func diaryButtonPressed() {
        
        print("photoAlbumPressed")
        
        //        setUIEnabled(true)
        
        // go to next view
        let controller = storyboard!.instantiateViewController(withIdentifier: "DiaryListViewController") as! DiaryListViewController
        controller.park = park
        controller.visit = visit
        controller.dataController = dataController
        navigationController!.pushViewController(controller, animated: true)
    }
    
    // MARK: addPhotoPressed - Add Photo
    
    @IBAction func addDiaryPressed() {
        
//        presentNewDiaryAlert()

        let photoPostingViewController = storyboard!.instantiateViewController(withIdentifier: "PhotoPostingViewController") as! PhotoPostingViewController

        photoPostingViewController.dataController = dataController
        photoPostingViewController.park = park
        photoPostingViewController.visit = visit

        navigationController!.pushViewController(photoPostingViewController, animated: true)
    }
    
    // MARK: newCollectionPressed - new collection button is pressed
    
//    @objc func newCollectionPressed() {
//
//        // Initialize
//        isLoadingNPSPlaces = true
//
//        setUIForDownloadingPlaces()
//        //        deleteAllPlaces()
//
//        //        downloadNPSPlacesFor(park)
//    }
    
    
    // MARK: removePhotosPressed - remove selected photos button is pressed
    
    @objc func removePhotosPressed(_ sender: UIButton?) {
        
        var selectedPhotos = [Photo]()
        selectedPhotoCells = selectedPhotoCells.sorted(by: {$0.item > $1.item})
        
        // Delete selected photos and perform batch update
        photoCollectionView.performBatchUpdates({
            
            // Delete photos from collectioView and collection
            for indexPath in self.selectedPhotoCells {
                self.photoCollectionView.deleteItems(at: [indexPath])
                self.photos.remove(at: indexPath.item)
            }
            
            // Delete photos from data store
            for indexPath in self.selectedPhotoCells {
                let aPlace = fetchedPhotoController.object(at: indexPath)
                selectedPhotos.append(aPlace)
            }
            
            performUIUpdatesOnMain {
                for aPhoto in selectedPhotos {
                    self.dataController.viewContext.delete(aPhoto)
                }
                
                try? self.dataController.viewContext.save()
            }
        }) {(completion) in
            
            // Fetch remaining photos from the data store
            self.setUpFetchedPhotoController(doRemoveAll: true)
            
            // Reset
            self.removePhotosButton?.isEnabled = false
 //           self.createNewPlacesButton()
 //           self.newPlacesButton?.isEnabled = true
            self.resetSelectedPhotoCells()
        }
    }
    
    // MARK: postVisit - post visit button is pressed
    
//    @objc func postVisit() {
//
//        print("postVisit")
//
//        //        setUIEnabled(true)
//
//        // go to next view
//        let controller = storyboard!.instantiateViewController(withIdentifier: "VisitListViewController") as! VisitListViewController
//        controller.park = park
//        controller.dataController = dataController
//        navigationController!.pushViewController(controller, animated: true)
//    }
    
    // MARK: addGestureRecognizer - configure tap and hold recognizer
    
    func addGestureRecognizer() {
        
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapLabel(_:)))
        
//        parkDescriptionLabel.isUserInteractionEnabled = true
//        parkDescriptionLabel.addGestureRecognizer(tapRecognizer)
    }
    
    // MARK: configure - configure the photos collection view flowLayout
    
    func configure(flowLayout: UICollectionViewFlowLayout, withSpace space: CGFloat, withColumns numOfColumns: CGFloat, withRows numOfRows: CGFloat) {
        
        let width: CGFloat = (UIScreen.main.bounds.size.width - ((numOfColumns + 1) * space)) / numOfColumns
        let height: CGFloat = (photoCollectionView.frame.size.height - ((numOfRows + 1) * space)) / numOfRows
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource

extension PhotoAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: numberOfSections - collectionView - Collection View Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return fetchedPhotoController.sections?.count ?? 1
    }
    
    // MARK: collectionView - numberOfItemsInSection - Collection View Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Set number of photos to display
//        var photoCount: Int
//        if (isLoadingPhotos) {
//
//            placeCount = Int(NPSClient.ParameterValues.PerPage)!
//        } else {
//
//            placeCount = places.count
//        }
        
        return photos.count
    }
    
    // MARK: collectionView - cellForItemAt - Collection View Cell Item
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionCell", for: indexPath) as! PhotoCollectionCell
        
        // Initialize
        
        cell.photoImage?.image = UIImage()
        
        if (PhotoAlbumViewController.hasPhotos) {
            
            cell.activityIndicatorView.startAnimating()
        }
        
        // Display photo
        if (!isLoadingPhotos) {
            
            if indexPath.item < photos.count {
                
                let aPlace = fetchedPhotoController.object(at: indexPath)
                if let imageData = aPlace.image {
                    
                    cell.photoImage?.image = UIImage(data: imageData)
                    if let title = aPlace.title {
                        cell.title?.text = "\(title)"
                    } else {
                        cell.title?.text = ""
                    }
                    cell.activityIndicatorView.stopAnimating()
                }
            }
        }
        
        toggleSelectedPhoto(cell, at: indexPath)
        
        return cell
    }
    
    // MARK: collectionView - didSelectItemAt - Select an item in Collection View
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        // Add or remove the highlighted cells to the list
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCollectionCell
        
        setSelectedPhoto(cell, at: indexPath)
        
        // create and set action button
        if selectedPhotoCells.count > 0 {
            
//            newPlacesButton?.isEnabled = false
            createRemovePhotosButton()
            removePhotosButton?.isEnabled = true
        } else {
            
            removePhotosButton?.isEnabled = false
//            createNewPlacesButton()
//            newPlacesButton?.isEnabled = true
        }
    }
}
