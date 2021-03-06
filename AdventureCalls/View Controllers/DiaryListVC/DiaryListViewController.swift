//
//  DiaryListViewController.swift
//  AdventureCalls
//
//  Created by Shirley on 6/12/18.
//  Copyright © 2018 Shirley Chan. All rights reserved.
//

import UIKit
import CoreData

// MARK: - DiaryListViewController: UIViewController

/**
 * This view controller presents a table view of diary entries for a visit to a park.
 */

class DiaryListViewController: UIViewController {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    
    var visit: Visit!
    var park: Park!
    
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
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    // MARK: Life Cycle
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        /* Grab the app delegate */
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataController = appDelegate.dataController

        // Set title to travel date
        
        if let travelDate = visit.travelDate {
            self.title = "Visit Diary \(dateFormatter.string(from: travelDate))"
        } else if let name = park.fullName {
            self.title = "\(appDelegate.filterName(name)) Visit Diary"
        } else {
            self.title = "National Park Visit Diary"
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
         
        if let rightButtons = navigationItem.rightBarButtonItems,
            rightButtons.count >= 2 {
            navigationItem.rightBarButtonItems?.remove(at: 1)
            navigationItem.rightBarButtonItems?.append(editButtonItem)
        }
        
        /* Grab the park data store */
        setUpFetchDiaryController()

        addButton.isEnabled = true
        updateEditButtonState()
        
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    // MARK: viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        setUpFetchDiaryController()
        if let indexPath = diaryTableView.indexPathForSelectedRow {
            
            diaryTableView.deselectRow(at: indexPath, animated: false)
            diaryTableView.reloadRows(at: [indexPath], with: .fade)
        }
        
        addButton.isEnabled = true
        updateEditButtonState()

        // Hide the toolbar
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    // MARK: viewDidDisappear
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
    }
    
    // MARK: Actions
    
    // MARK: addDiaryPressed - Add Diary
    
    @IBAction func addDiaryPressed() {
        
        presentNewDiaryAlert()
        
        updateEditButtonState()
    }
    
    // MARK: backButtonPressed - back button is pressed
    
    @IBAction func backButtonPressed() {
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: homeButtonPressed - back button is pressed
    
    @IBAction func homeButtonPressed() {
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: photoAlbumPressed - photo album button is pressed
    
    @IBAction func photoAlbumPressed() {
        
        // go to next view
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "PhotoAlbumViewController") as! PhotoAlbumViewController
        controller.park = park
        controller.visit = visit
        controller.dataController = dataController
        navigationController!.pushViewController(controller, animated: true)
    }
    
    // MARK: addDiary - Adds a new diary to the data store
    
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
        
        addButton.isEnabled = (editing == false)
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
                        self?.deleteDiary(at: indexPath)
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    // MARK: presentNewDiaryAlert - Display an alert prompting the user to name a new diary.
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryTableCell", for: indexPath) as! DiaryTableCell
        
        // Configure cell
        
        if let title = aDiary.title {
            cell.diaryTitleLabel.text = title
        } else {
            cell.diaryTitleLabel.text = ""
        }
        
        return cell
    }
    
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
