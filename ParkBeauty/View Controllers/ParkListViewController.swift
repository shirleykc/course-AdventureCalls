//
//  ParkListViewController.swift
//  ParkBeauty
//
//  Created by Shirley on 6/5/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import CoreData
import MapKit

// MARK: - ParkListViewController: UIViewController

/**
 * This view controller presents a table view of parks.
 */

class ParkListViewController: UIViewController {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    
    var parks = [Park]()
//    var studentLocations: StudentLocationCollection!
    
    var dataController: DataController!
    
    var fetchedParkController: NSFetchedResultsController<Park>!
//    var fetchedPlaceController: NSFetchedResultsController<Place>!

    // MARK: Outlets
    
    @IBOutlet weak var parkTableView: UITableView!
//    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Grab the app delegate */
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataController = appDelegate.dataController
        
        /* Grab the park data store */
        setUpFetchParkController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpFetchParkController()
        if let indexPath = parkTableView.indexPathForSelectedRow {
            parkTableView.deselectRow(at: indexPath, animated: false)
            parkTableView.reloadRows(at: [indexPath], with: .fade)
        }
        
        // Hide the toolbar
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedParkController = nil
    }
    
    /// Adds a new park to the end of the `parks` array
    func addPark(name: String) {
        let park = Park(context: dataController.viewContext)
        park.name = name
        park.creationDate = Date()
        
        try? dataController.viewContext.save()
    }
    
    /// Deletes the park at the specified index path
    func deletePark(at indexPath: IndexPath) {
        let parkToDelete = fetchedParkController.object(at: indexPath)
        dataController.viewContext.delete(parkToDelete)
        try? dataController.viewContext.save()
    }
    
    func updateEditButtonState() {
        if let sections = fetchedParkController.sections {
            navigationItem.rightBarButtonItem?.isEnabled = sections[0].numberOfObjects > 0
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        parkTableView.setEditing(editing, animated: animated)
    }

    // -------------------------------------------------------------------------
    // MARK: - Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        // If this is a ParkListViewController, we'll configure its Places
//        if let vc = segue.destination as? PlaceCollectionViewController {
//            if let indexPath = parkTableView.indexPathForSelectedRow {
//                vc.park = fetchedParkController.object(at: indexPath)
//                vc.dataController = dataController
//                print("prepare")
//                //                vc.onDelete = { [weak self] in
//                //                    if let indexPath = self?.tableView.indexPathForSelectedRow {
//                //                        self?.deleteNote(at: indexPath)
//                //                        self?.navigationController?.popViewController(animated: true)
//                //                    }
//                //                }
//            }
//        }
//    }
    
    // -------------------------------------------------------------------------
    // MARK: - Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // If this is a NotesListViewController, we'll configure its `Notebook`
//        if let vc = segue.destination as? NotesListViewController {
//            if let indexPath = tableView.indexPathForSelectedRow {
//                vc.notebook = fetchedResultsController.object(at: indexPath)
//                vc.dataController = dataController
//            }
//        }
//    }
}

extension ParkListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // -------------------------------------------------------------------------
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedParkController.sections?.count ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedParkController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aPark = fetchedParkController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParkTableCell", for: indexPath) as! ParkTableCell
        
        // Configure cell
        var name = aPark.name
        if name == nil {
            name = ""
        }
        cell.parkNameLabel?.text = "\(name!)"
        
        var stateCode = aPark.stateCode
        if stateCode == nil {
            stateCode = ""
        }
        cell.parkStateLabel?.text = "\(stateCode!)"
        
        var parkCode = aPark.parkCode
        if parkCode == nil {
            parkCode = ""
        } else {
            parkCode = parkCode?.uppercased()
        }
        cell.parkCodeLabel?.text = "\(parkCode!)"
        
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deletePark(at: indexPath)
        default: () // Unsupported
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "PlaceCollectionViewController") as! PlaceCollectionViewController
        let aPark = fetchedParkController.object(at: indexPath)
        controller.park = aPark
        controller.annotation = Annotation(park: aPark)
        controller.dataController = dataController
        
        print("didSelectRowAt")
        navigationController!.pushViewController(controller, animated: true)
    }
}

//// MARK: - LocationListViewController: UITableViewDelegate, UITableViewDataSource
//
//extension LocationListViewController: UITableViewDelegate, UITableViewDataSource {
//
//    // MARK: tableView - cellForRowAt
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        /* Get cell type */
//        let cellReuseIdentifier = "StudentLocationTableCell"
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! StudentLocationTableCell
//
//        if let locations = studentLocations.locations {
//            let location = locations[(indexPath as NSIndexPath).row]
//
//            /* Set cell defaults */
//            var firstName = location.firstName
//            if firstName == nil {
//                firstName = ""
//            }
//            var lastName = location.lastName
//            if lastName == nil {
//                lastName = ""
//            }
//            cell.studentNameLabel?.text = "\(firstName!) \(lastName!)"
//
//            var mediaURL = location.mediaURL
//            if mediaURL == nil {
//                mediaURL = ""
//            }
//            cell.mediaURLLabel?.text = "\(mediaURL!)"
//        }
//
//        return cell
//    }
//
//    // MARK: tableView - numberOfRowsInSection
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let locations = studentLocations.locations {
//            return locations.count
//        } else {
//            return 0
//        }
//    }
//
//    // MARK: tableView - didSelectRowAt
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let locations = studentLocations.locations else {
//            appDelegate.presentAlert(self, "No student locations available")
//            return
//        }
//
//        let studentInformation = locations[(indexPath as NSIndexPath).row]
//
//        // deselect the selected row
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        guard let mediaURLString = studentInformation.mediaURL else {
//            appDelegate.presentAlert(self, "Invalid URL")
//            return
//        }
//
//        appDelegate.validateURLString(mediaURLString) { (success, url, errorString) in
//            performUIUpdatesOnMain {
//                if success {
//                    UIApplication.shared.open(url!, options: [:]) { (success) in
//                        if !success {
//                            self.appDelegate.presentAlert(self, "Cannot open URL")
//                        }
//                    }
//                } else {
//                    self.appDelegate.presentAlert(self, errorString)
//                }
//            }
//        }
//    }
//
//    // MARK: tableView - heightForRowAt
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
//}

extension ParkListViewController:NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            parkTableView.insertRows(at: [newIndexPath!], with: .fade)
//            break
        case .delete:
            parkTableView.deleteRows(at: [indexPath!], with: .fade)
//            break
        case .update:
            parkTableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            parkTableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: parkTableView.insertSections(indexSet, with: .fade)
        case .delete: parkTableView.deleteSections(indexSet, with: .fade)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        parkTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        parkTableView.endUpdates()
    }    
}

extension ParkListViewController {
    
    func setUpFetchParkController() {
        let fetchRequest:NSFetchRequest<Park> = Park.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedParkController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedParkController.delegate = self
        do {
            try fetchedParkController.performFetch()
            print("ParkListViewController - performFetch")
        } catch {
            fatalError("The fetch parks could not be performed: \(error.localizedDescription)")
        }
    }
    
//    // MARK: setupFetchPlaceController - fetch the places for the park in data store
//    
//    func setupFetchPlaceController(_ park: Park) -> [Place] {
//        
//        var places = [Place]()
//        
//        let fetchRequest:NSFetchRequest<Place> = Place.fetchRequest()
//        let predicate = NSPredicate(format: "park == %@", argumentArray: [park])
//        fetchRequest.predicate = predicate
//        fetchRequest.sortDescriptors = []
//        
//        fetchedPlaceController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
//        
//        do {
//            try fetchedPlaceController.performFetch()
//            if let results = fetchedPlaceController?.fetchedObjects {
//                places = results
//            }
//        } catch {
//            displayError("Cannot fetch places")
//        }
//        
//        return places
//    }
//
//    // MARK: displayError - Display error
//    
//    func displayError(_ errorString: String?) {
//        
//        print(errorString!)
//        dismiss(animated: true, completion: nil)
//    }
}
