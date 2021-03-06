//
//  PhotoAlbumViewController.swift
//  AdventureCalls
//
//  Created by Shirley on 6/12/18.
//  Copyright © 2018 Shirley Chan. All rights reserved.
//

import UIKit
import CoreData

// MARK: PhotoAlbumViewController

class PhotoAlbumViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    
    // The park visit whose photos are being displayed
    var park: Park!
    var visit: Visit!
    var photos = [Photo]()
    
    var dataController:DataController!
    var fetchedPhotoController:NSFetchedResultsController<Photo>!
    
    var selectedPhotoCells = [IndexPath]()
    
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
    @IBOutlet weak var removePhotosButton: UIBarButtonItem!
    @IBOutlet weak var addPhotoButton: UIBarButtonItem!
    
    // MARK: Life Cycle
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Grab the app delegate
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Set title to travel date
        
        if let travelDate = visit.travelDate {
            self.title = "Visit Photos \(dateFormatter.string(from: travelDate))"
        } else if let name = park.fullName {
            self.title = "\(appDelegate.filterName(name)) Visit Photos"
        } else {
            self.title = "National Park Visit Photos"
        }
        
        if let parkCode = park.parkCode {
            parkCodeLabel?.text = parkCode.uppercased()
        } else {
            parkCodeLabel?.text = ""
        }
        
        if let parkName = park.fullName {
            parkNameLabel?.text = appDelegate.filterName(parkName)
        } else {
            parkNameLabel?.text = ""
        }
        
        self.navigationController?.setToolbarHidden(false, animated: true)
                
        photoCollectionView.delegate = self
        
        // Grab the photos
        
        setUpFetchedPhotoController(doRemoveAll: false)
        
        // Implement flowLayout here.
        
        let photoFlowLayout = photoCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        configure(flowLayout: photoFlowLayout!, withSpace: 1, withColumns: 3, withRows: 3)
        
        addPhotoButton?.isEnabled = true
        removePhotosButton?.isEnabled = false
    }
    
    // MARK: viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Grab the photos
        
        setUpFetchedPhotoController(doRemoveAll: false)
        
        addPhotoButton?.isEnabled = true
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        photoCollectionView.reloadData()
    }
    
    // MARK: viewDidAppear
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        addPhotoButton?.isEnabled = true
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        photoCollectionView.reloadData()
    }
    
    // MARK: viewDidDisappear
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        fetchedPhotoController = nil
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
        
        // go to next view
        let controller = storyboard!.instantiateViewController(withIdentifier: "DiaryListViewController") as! DiaryListViewController
        controller.park = park
        controller.visit = visit
        controller.dataController = dataController
        
        navigationController!.pushViewController(controller, animated: true)
    }
    
    // MARK: addPhotoPressed - Add Photo
    
    @IBAction func addPhotoPressed() {
        
        let photoPostingViewController = storyboard!.instantiateViewController(withIdentifier: "PhotoPostingViewController") as! PhotoPostingViewController

        photoPostingViewController.dataController = dataController
        photoPostingViewController.park = park
        photoPostingViewController.visit = visit

        navigationController!.pushViewController(photoPostingViewController, animated: true)
    }
    
    // MARK: removePhotosPressed - remove selected photos button is pressed
    
    @IBAction func removePhotosPressed(_ sender: Any?) {
        
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
            self.resetSelectedPhotoCells()
        }
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
        
        if indexPath.item < photos.count {
            
            let aPhoto = fetchedPhotoController.object(at: indexPath)
            if let imageData = aPhoto.image {
                
                cell.photoImage?.image = UIImage(data: imageData)
                if let title = aPhoto.title {
                    cell.title?.text = "\(title)"
                } else {
                    cell.title?.text = ""
                }
                cell.activityIndicatorView.stopAnimating()
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
            
            addPhotoButton?.isEnabled = false
            removePhotosButton?.isEnabled = true
        } else {
            
            addPhotoButton?.isEnabled = true
            removePhotosButton?.isEnabled = false
        }
    }
}
