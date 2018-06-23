//
//  ParkListViewController.swift
//  ParkBeauty
//
//  Created by Shirley on 6/5/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import CoreData

// MARK: - ParkListViewController: UIViewController

/**
 * This view controller presents a table view of parks.
 */

class ParkListViewController: UIViewController {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var dataController: DataController!

    var parks = [Park]()
    
    var fetchedParkController: NSFetchedResultsController<Park>!

    // MARK: Outlets
    
    @IBOutlet weak var parkTableView: UITableView!
    
    // MARK: Life Cycle
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /* Grab the app delegate */
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataController = appDelegate.dataController
    }
    
    // MARK: viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        /* Grab the park data store */

        setUpFetchParkController()
        
        if let indexPath = parkTableView.indexPathForSelectedRow {
            
            parkTableView.deselectRow(at: indexPath, animated: false)
            parkTableView.reloadRows(at: [indexPath], with: .fade)
        }
        
        // Hide the toolbar
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    // MARK: viewDidDisappear
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        // reset
        
        fetchedParkController = nil
    }
    
    // MARK: deletePark - Deletes the park at the specified index path
    
    func deletePark(at indexPath: IndexPath) {

        let parkToDelete = fetchedParkController.object(at: indexPath)
        dataController.viewContext.delete(parkToDelete)

        try? dataController.viewContext.save()
    }

//    func updateEditButtonState() {
//        if let sections = fetchedParkController.sections {
//            navigationItem.rightBarButtonItem?.isEnabled = sections[0].numberOfObjects > 0
//        }
//    }
//
//    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: animated)
//        parkTableView.setEditing(editing, animated: animated)
//    }
}

// MARK: ParkListViewController: UITableViewDelegate, UITableViewDataSource

extension ParkListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: numberOfSections - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return fetchedParkController.sections?.count ?? 1
    }

    // MARK: tableView - numberOfRowsInSection
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedParkController.sections?[section].numberOfObjects ?? 0
    }

    // MARK: tableView - cellForRowAt
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aPark = fetchedParkController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParkTableCell", for: indexPath) as! ParkTableCell
        
        // Configure cell
        
        var name = aPark.fullName ?? aPark.name
        if name == nil {
            name = ""
        }
        name = appDelegate.filterName(name)
        
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

    // MARK: tableView - commit
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
            
        case .delete: deletePark(at: indexPath)
        
        default: () // Unsupported
        }
    }
    
    // MARK: tableView - didSelectRowAt
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "PlaceCollectionViewController") as! PlaceCollectionViewController
        
        let aPark = fetchedParkController.object(at: indexPath)
        controller.park = aPark
        controller.annotation = Annotation(park: aPark)
        controller.dataController = dataController
        
        navigationController!.pushViewController(controller, animated: true)
    }
}

// MARK: ParkListViewController:NSFetchedResultsControllerDelegate

extension ParkListViewController:NSFetchedResultsControllerDelegate {
    
    // MARK: controller - didChange object
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .insert:
            parkTableView.insertRows(at: [newIndexPath!], with: .fade)
            
        case .delete:
            parkTableView.deleteRows(at: [indexPath!], with: .fade)
            
        case .update:
            parkTableView.reloadRows(at: [indexPath!], with: .fade)
            
        case .move:
            parkTableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    // MARK: controller - didChange section
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
            
        case .insert: parkTableView.insertSections(indexSet, with: .fade)
            
        case .delete: parkTableView.deleteSections(indexSet, with: .fade)
            
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }
    }
    
    // MARK: controllerWillChangeContent
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        parkTableView.beginUpdates()
    }
    
    // MARK: controllerDidChangeContent
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        parkTableView.endUpdates()
    }    
}
