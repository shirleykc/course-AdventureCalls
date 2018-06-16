//
//  DiaryListViewController.swift
//  ParkBeauty
//
//  Created by Shirley on 6/12/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import CoreData
import MapKit

// MARK: - DiaryListViewController: UIViewController

/**
 * This view controller presents a table view of parks.
 */

class DiaryListViewController: UIViewController {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    
    var visit: Visit!
    var diaries = [Diary]()
    //    var studentLocations: StudentLocationCollection!
    
    var dataController: DataController!
    
    var fetchedDiaryController: NSFetchedResultsController<Diary>!
    //    var fetchedPlaceController: NSFetchedResultsController<Place>!
    
    // MARK: Outlets
    
    @IBOutlet weak var diaryTableView: UITableView!
    //    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Grab the app delegate */
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataController = appDelegate.dataController
        
        /* Grab the park data store */
        setUpFetchDiaryController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpFetchDiaryController()
        if let indexPath = diaryTableView.indexPathForSelectedRow {
            diaryTableView.deselectRow(at: indexPath, animated: false)
            diaryTableView.reloadRows(at: [indexPath], with: .fade)
        }
        
        // Hide the toolbar
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedDiaryController = nil
    }
    
    /// Adds a new diary to the end of the `diaries` array
    func addDiary(name: String) {
        let diary = Diary(context: dataController.viewContext)
//        diary.name = name
        diary.creationDate = Date()
        
        try? dataController.viewContext.save()
    }
    
    /// Deletes the diary at the specified index path
    func deleteDiary(at indexPath: IndexPath) {
        let diaryToDelete = fetchedDiaryController.object(at: indexPath)
        dataController.viewContext.delete(diaryToDelete)
        try? dataController.viewContext.save()
    }
    
    func updateEditButtonState() {
        if let sections = fetchedDiaryController.sections {
            navigationItem.rightBarButtonItem?.isEnabled = sections[0].numberOfObjects > 0
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        diaryTableView.setEditing(editing, animated: animated)
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

extension DiaryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // -------------------------------------------------------------------------
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedDiaryController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedDiaryController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aPark = fetchedDiaryController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryTableCell", for: indexPath) as! DiaryTableCell
        
        // Configure cell
//        var name = aDiary.name
//        if name == nil {
//            name = ""
//        }
//        cell.parkNameLabel?.text = "\(name!)"
//
//        var stateCode = aPark.stateCode
//        if stateCode == nil {
//            stateCode = ""
//        }
//        cell.parkStateLabel?.text = "\(stateCode!)"
//
//        var parkCode = aPark.parkCode
//        if parkCode == nil {
//            parkCode = ""
//        } else {
//            parkCode = parkCode?.uppercased()
//        }
//        cell.parkCodeLabel?.text = "\(parkCode!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteDiary(at: indexPath)
        default: () // Unsupported
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "PlaceCollectionViewController") as! PlaceCollectionViewController
        let aDiary = fetchedDiaryController.object(at: indexPath)
//        controller. = aDiary
//        controller.annotation = Annotation(park: aPark)
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

extension DiaryListViewController:NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            diaryTableView.insertRows(at: [newIndexPath!], with: .fade)
        //            break
        case .delete:
            diaryTableView.deleteRows(at: [indexPath!], with: .fade)
        //            break
        case .update:
            diaryTableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            diaryTableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: diaryTableView.insertSections(indexSet, with: .fade)
        case .delete: diaryTableView.deleteSections(indexSet, with: .fade)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        diaryTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        diaryTableView.endUpdates()
    }
}
