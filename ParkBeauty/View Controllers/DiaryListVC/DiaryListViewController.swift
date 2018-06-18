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
    var park: Park!
    var diaries = [Diary]()
    
    var dataController: DataController!
    
    var fetchedDiaryController: NSFetchedResultsController<Diary>!
    
    // A date formatter for date text
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    // MARK: Outlets
    
    @IBOutlet weak var parkCodeLabel: UILabel!
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var diaryTableView: UITableView!
    //    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: Life Cycle
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DiaryListViewController viewDidLoad")
        /* Grab the app delegate */
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataController = appDelegate.dataController

        // Set title to travel date
        
        if let travelDate = visit.travelDate {
            self.title = dateFormatter.string(from: travelDate)
        } else if let name = park.fullName {
            self.title = name
        } else {
            self.title = "National Park Visit Diary"
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
        
        /* Grab the park data store */
        setUpFetchDiaryController()
        
        createTopBarButtons(navigationItem)
    }
    
    // MARK: viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        print("DiaryListViewController viewWillAppear")

        setUpFetchDiaryController()
        if let indexPath = diaryTableView.indexPathForSelectedRow {
            
            diaryTableView.deselectRow(at: indexPath, animated: false)
            diaryTableView.reloadRows(at: [indexPath], with: .fade)
        }
        
        // Hide the toolbar
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    // MARK: viewDidDisappear
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        fetchedDiaryController = nil
    }
    
    // MARK: Actions
    
    // MARK: addDiaryPressed - Add Diary
    
    @objc func addDiaryPressed() {
        
        // go to search park view
        
        let diaryDetailViewController = storyboard!.instantiateViewController(withIdentifier: "DiaryDetailViewController") as! DiaryDetailViewController
        
        diaryDetailViewController.dataController = dataController
        diaryDetailViewController.park = park
        diaryDetailViewController.visit = visit
        
        navigationController!.pushViewController(diaryDetailViewController, animated: true)
    }
    
    // MARK: backButtonPressed - back button is pressed
    
    @objc func backButtonPressed() {
        
        navigationController?.popViewController(animated: true)
    }
    
    /// Adds a new diary to the data store
//    func addDiary(title: String?, note: String?) {
//        let diary = Diary(context: dataController.viewContext)
////        diary.name = name
//        diary.title = title
//        diary.creationDate = Date()
//
//        try? dataController.viewContext.save()
//    }
    
    // MARK: deleteDiary - Deletes the diary at the specified index path
    
    func deleteDiary(at indexPath: IndexPath) {
        
        let diaryToDelete = fetchedDiaryController.object(at: indexPath)
        dataController.viewContext.delete(diaryToDelete)
        
        try? dataController.viewContext.save()
    }
    
    // MARK: updateEditButtonState - Enable or disable the Edit button
    
    func updateEditButtonState() {
        
        if let sections = fetchedDiaryController.sections {
            
            navigationItem.rightBarButtonItem?.isEnabled = sections[0].numberOfObjects > 0
        }
    }
    
    // MARK: setEditing - set editing state
    
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

// MARK: DiaryListViewController: UITableViewDelegate, UITableViewDataSource

extension DiaryListViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: numberOfSections
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return fetchedDiaryController.sections?.count ?? 1
    }
    
    // MARK: tableView - numberOfRowsInSection
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedDiaryController.sections?[section].numberOfObjects ?? 0
    }
    
    // MARK: tableView - cellForRowAt
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aDiary = fetchedDiaryController.object(at: indexPath)
        print("aDiary: \(indexPath) - \(aDiary)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryTableCell", for: indexPath) as! DiaryTableCell
        
        // Configure cell
        
        if let title = aDiary.title {
            cell.diaryTitleLabel.text = title
        } else {
            cell.diaryTitleLabel.text = ""
        }
        
        if let count = visit.diaries?.count {
            let pageString = count == 1 ? "page" : "pages"
            cell.pageCountLabel.text = "\(count) \(pageString)"
        }
        
        return cell
    }
    
//    // MARK: tableView - didSelectRowAt
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let controller = storyboard!.instantiateViewController(withIdentifier: "DiaryDetailViewController") as! DiaryDetailViewController
//
//        let aDiary = fetchedDiaryController.object(at: indexPath)
//        controller.visit = visit
//        controller.park = park
//        controller.diary = aDiary
//        controller.dataController = dataController
//
//        print("DiaryListViewController didSelectRowAt")
//        navigationController!.pushViewController(controller, animated: true)
//    }
    
    // MARK: tableView - commit
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
            
        case .delete: deleteDiary(at: indexPath)
            
        default: () // Unsupported
        }
    }
    
    // MARK: - prepare - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // If this is a DiaryDetailsViewController, we'll configure its `Diary`
        // and its delete action
        
        if let vc = segue.destination as? DiaryDetailViewController {
            if let indexPath = diaryTableView.indexPathForSelectedRow {
                vc.diary = fetchedDiaryController.object(at: indexPath)
                vc.park = park
                vc.visit = visit
                vc.dataController = dataController
                
                vc.onDelete = { [weak self] in
                    if let indexPath = self?.diaryTableView.indexPathForSelectedRow {
                        self?.deleteDiary(at: indexPath)
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}
    
// MARK: DiaryListViewController:NSFetchedResultsControllerDelegate

extension DiaryListViewController:NSFetchedResultsControllerDelegate {
    
    // MARK: controller - didChange an object
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            
        case .insert:
            diaryTableView.insertRows(at: [newIndexPath!], with: .fade)
            
        case .delete:
            diaryTableView.deleteRows(at: [indexPath!], with: .fade)
            
        case .update:
            diaryTableView.reloadRows(at: [indexPath!], with: .fade)
            
        case .move:
            diaryTableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    // MARK: controller - didChange section
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
            
        case .insert: diaryTableView.insertSections(indexSet, with: .fade)
            
        case .delete: diaryTableView.deleteSections(indexSet, with: .fade)
            
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }
    }
    
    // MARK: controllerWillChangeContent
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        diaryTableView.beginUpdates()
    }
    
    // MARK: controllerDidChangeContent
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        diaryTableView.endUpdates()
    }
}
