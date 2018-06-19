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
 * This view controller presents a table view of diary entries for a visit to a park.
 */

class DiaryListViewController: UIViewController {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    
    var visit: Visit!
    var park: Park!
    var diaries: [Diary]!
    
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
    @IBOutlet weak var editButton: UIBarButtonItem!
    
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
            self.title = "Visit on \(dateFormatter.string(from: travelDate))"
        } else if let name = park.fullName {
            self.title = "\(name) Visit Diary"
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
 
 //       createTopBarButtons(navigationItem)
        
        /* Grab the park data store */
        setUpFetchDiaryController()
        
        editButton = editButtonItem
        updateEditButtonState()
        

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
        
        updateEditButtonState()

        // Hide the toolbar
//        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    // MARK: viewDidDisappear
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
//        fetchedDiaryController = nil
    }
    
    // MARK: Actions
    
    // MARK: addDiaryPressed - Add Diary
    
//    @objc func addDiaryPressed() {
    @IBAction func addDiaryPressed() {
        
        presentNewDiaryAlert()
        
//        let diaryDetailViewController = storyboard!.instantiateViewController(withIdentifier: "DiaryDetailViewController") as! DiaryDetailViewController
//
//        diaryDetailViewController.dataController = dataController
//        diaryDetailViewController.fetchedDiaryController = fetchedDiaryController
//        diaryDetailViewController.park = park
//        diaryDetailViewController.visit = visit
//
//        let diary = Diary(context: dataController.viewContext)
//        diaryDetailViewController.diary = diary
//
//        navigationController!.pushViewController(diaryDetailViewController, animated: true)
    }
    
    // MARK: backButtonPressed - back button is pressed
    
//    @objc func backButtonPressed() {
    @IBAction func backButtonPressed() {
        
        navigationController?.popViewController(animated: true)
    }
    
    /// Adds a new diary to the data store
    func addDiary(title: String) {
        let diary = Diary(context: dataController.viewContext)
        diary.title = title
        diary.visit = visit
        diary.creationDate = Date()

        try? dataController.viewContext.save()
    }
    
    // MARK: deleteDiary - Deletes the diary at the specified index path
    
    func deleteDiary(at indexPath: IndexPath) {
        
        let diaryToDelete = fetchedDiaryController.object(at: indexPath)
        dataController.viewContext.delete(diaryToDelete)
        
        try? dataController.viewContext.save()
    }
    
    // MARK: updateEditButtonState - Enable or disable the Edit button
    
    func updateEditButtonState() {
        
        if let sections = fetchedDiaryController.sections {
            
            if let rightButtons = navigationItem.rightBarButtonItems,
                rightButtons.count >= 2 {
                rightButtons[1].isEnabled = sections[0].numberOfObjects > 0
                navigationItem.rightBarButtonItems = rightButtons
            }
        }
    }
    
    // MARK: setEditing - set editing state
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        
        diaryTableView.setEditing(editing, animated: animated)
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
                vc.fetchedDiaryController = fetchedDiaryController
                
                vc.onDelete = { [weak self] in
                    if let indexPath = self?.diaryTableView.indexPathForSelectedRow {
 //                       self?.fetchedDiaryController = vc.fetchedDiaryController
                        self?.deleteDiary(at: indexPath)
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    /// Display an alert prompting the user to name a new notebook. Calls
    /// `addNotebook(name:)`.
    func presentNewDiaryAlert() {
        let alert = UIAlertController(title: "New Diary", message: "Enter a title for this diary", preferredStyle: .alert)
        
        // Create actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            if let title = alert.textFields?.first?.text {
                self?.addDiary(title: title)
            }
        }
        saveAction.isEnabled = false
        
        // Add a text field
        alert.addTextField { textField in
            textField.placeholder = "Title"
            NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange, object: textField, queue: .main) { notif in
                if let text = textField.text, !text.isEmpty {
                    saveAction.isEnabled = true
                } else {
                    saveAction.isEnabled = false
                }
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
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
        
        return fetchedDiaryController.sections?[0].numberOfObjects ?? 0
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
        
//        if let count = visit.diaries?.count {
//            let pageString = count == 1 ? "page" : "pages"
//            cell.pageCountLabel.text = "\(count) \(pageString)"
//        }
        
//        let aNote = fetchedResultsController.object(at: indexPath)
//        let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.defaultReuseIdentifier, for: indexPath) as! NoteCell
//
//        // Configure cell
//        cell.textPreviewLabel.attributedText = aNote.attributedText
//
//        if let creationDate = aNote.creationDate {
//            cell.dateLabel.text = dateFormatter.string(from: creationDate)
//        }
//
//        return cell
        
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
    
    // MARK: tableView - heightForRowAt
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
    
// MARK: DiaryListViewController:NSFetchedResultsControllerDelegate

extension DiaryListViewController:NSFetchedResultsControllerDelegate {
    
    // MARK: controller - didChange an object
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            
        case .insert:
            diaryTableView.insertRows(at: [newIndexPath!], with: .fade)
            break
            
        case .delete:
            diaryTableView.deleteRows(at: [indexPath!], with: .fade)
            break
            
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
