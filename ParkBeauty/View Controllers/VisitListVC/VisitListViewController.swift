//
//  VisitListViewController.swift
//  ParkBeauty
//
//  Created by Shirley on 6/10/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import CoreData

// MARK: VisitListViewController: UIViewController

/**
 * This view controller presents a table view of visits.
 */

class VisitListViewController: UIViewController {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var dataController:DataController!
        
    // The park whose visits are being displayed
    
    var park: Park!
    var visits = [Visit]()
    
    var fetchedVisitController:NSFetchedResultsController<Visit>!
    
    // Images for star rating
    
    let starImage:  UIImage = UIImage(named: "icon_star.png")!
    let blankImage: UIImage = UIImage()
    
    // A date formatter for date text
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    // MARK: IBOutlets
    
    // A table view that displays a list of visits
    
    @IBOutlet weak var visitTableView: UITableView!
    
    // MARK: Life Cycle
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Grab the app delegate
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataController = appDelegate.dataController
        
        // Set title to park name
        if let name = park.fullName {
            self.title = name
        } else {
            self.title = "National Park Visits"
        }
        
//        setupFetchedVisitController()

        createTopBarButtons(navigationItem)
        navigationController?.setToolbarHidden(false, animated: true)
//        createBottomBarButton()
    }
    
    // MARK: viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        /* Grab the park data store */

        setupFetchedVisitController()
        
        if let indexPath = visitTableView.indexPathForSelectedRow {
            
            visitTableView.deselectRow(at: indexPath, animated: false)
            visitTableView.reloadRows(at: [indexPath], with: .fade)
        }
        
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    // MARK: viewDidDisappear
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        fetchedVisitController = nil
    }
    
    // MARK: - Actions
    
    // MARK: homeButtonPressed - back button is pressed
    
    @IBAction func homeButtonPressed() {
        
        navigationController?.popToRootViewController(animated: true)
    }
    
//    @IBAction func addTapped(sender: Any) {
//        presentNewNotebookAlert()
//    }
    
    // MARK: addVisitPressed - Add Visit
    
    @objc func addVisitPressed() {
        
        // go to visit info posting view
        
        let visitInfoPostingViewController = storyboard!.instantiateViewController(withIdentifier: "VisitInfoPostingViewController") as! VisitInfoPostingViewController
        
        visitInfoPostingViewController.dataController = dataController
        visitInfoPostingViewController.park = park
        
        navigationController!.pushViewController(visitInfoPostingViewController, animated: true)
    }
    
    // MARK: backButtonPressed - back button is pressed
    
    @objc func backButtonPressed() {
        
        navigationController?.popViewController(animated: true)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Editing
    
    /// Display an alert prompting the user to name a new vist. Calls
    /// `addVisit(name:)`.
//    func presentNewNotebookAlert() {
//        let alert = UIAlertController(title: "New Visit", message: "Enter a name for this visit", preferredStyle: .alert)
//
//        // Create actions
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
//            if let name = alert.textFields?.first?.text {
//                //                self?.addVisit(name: <#T##String#>)(name: name)
//            }
//        }
//        saveAction.isEnabled = false
//
//        // Add a text field
//        alert.addTextField { textField in
//            textField.placeholder = "Name"
//            NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange, object: textField, queue: .main) { notif in
//                if let text = textField.text, !text.isEmpty {
//                    saveAction.isEnabled = true
//                } else {
//                    saveAction.isEnabled = false
//                }
//            }
//        }
//
//        alert.addAction(cancelAction)
//        alert.addAction(saveAction)
//        present(alert, animated: true, completion: nil)
//    }
    
    // MARK: addVisit - Adds a new visit to the data store
    
    func addVisit(title: String) {
        
        print("VisitListViewController - addVisit: \(title)")
        let visit = Visit(context: dataController.viewContext)
        visit.title = title
        visit.creationDate = Date()
        visit.park = park
        
        try? dataController.viewContext.save()
    }
    
    // MARK: deleteVisit - Deletes the visit at the specified index path
    
    func deleteVisit(at indexPath: IndexPath) {
        
        let visitToDelete = fetchedVisitController.object(at: indexPath)
        dataController.viewContext.delete(visitToDelete)
        
        try? dataController.viewContext.save()
    }
    
    // MARK: updateEditButtonState - enable or disable edit button
    
    func updateEditButtonState() {
        
        if let sections = fetchedVisitController.sections {
            
            navigationItem.rightBarButtonItem?.isEnabled = sections[0].numberOfObjects > 0
        }
    }
    
    // MARK: setEditing - set the table view edit state
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        
        visitTableView.setEditing(editing, animated: animated)
    }
}

// MARK: VisitListViewController: UITableViewDelegate, UITableViewDataSource

extension VisitListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: numberOfSections
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return fetchedVisitController.sections?.count ?? 1
    }
    
    // MARK: tableView - numberOfRowsInSection
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedVisitController.sections?[section].numberOfObjects ?? 0
    }
    
    // MARK: tableView - cellForRowAt
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aVisit = fetchedVisitController.object(at: indexPath)
        print("aVisit: \(indexPath) - \(aVisit)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "VisitTableCell", for: indexPath) as! VisitTableCell
        
        // Configure cell
        
        if let title = aVisit.title {
            cell.visitTitleLabel.text = title
        } else {
            cell.visitTitleLabel.text = ""
        }
        
        if let travelDate = aVisit.travelDate {
            cell.visitDateLabel.text = dateFormatter.string(from: travelDate)
        } else {
            cell.visitDateLabel.text = ""
        }
        
        let rating = aVisit.rating
        if rating >= 0 {
            cell.ratingStar1Image.image = getRatingStarImage(starNumber: 1, forRating: rating)
            cell.ratingStar2Image.image = getRatingStarImage(starNumber: 2, forRating: rating)
            cell.ratingStar3Image.image = getRatingStarImage(starNumber: 3, forRating: rating)
            cell.ratingStar4Image.image = getRatingStarImage(starNumber: 4, forRating: rating)
            cell.ratingStar5Image.image = getRatingStarImage(starNumber: 5, forRating: rating)
        }        

//        if let count = aNotebook.notes?.count {
//            let pageString = count == 1 ? "page" : "pages"
//            cell.pageCountLabel.text = "\(count) \(pageString)"
//        }
        
        return cell
    }
    
    // MARK: tableView - didSelectRowAt
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        let controller = storyboard!.instantiateViewController(withIdentifier: "DiaryListViewController") as! DiaryListViewController
        
        let aVisit = fetchedVisitController.object(at: indexPath)
        controller.visit = aVisit
        controller.park = park
        controller.dataController = dataController
        
        print("VisitListViewController didSelectRowAt")
        navigationController!.pushViewController(controller, animated: true)
    }
    
    // MARK: tableView - commit
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
            
        case .delete: deleteVisit(at: indexPath)
            
        default: () // Unsupported
        }
    }
    
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

// MARK: VisitListViewController:NSFetchedResultsControllerDelegate

extension VisitListViewController:NSFetchedResultsControllerDelegate {
    
    // MARK: controller - didChange an object
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            
        case .insert:
            visitTableView.insertRows(at: [newIndexPath!], with: .fade)

        case .delete:
            visitTableView.deleteRows(at: [indexPath!], with: .fade)
 
        case .update:
            visitTableView.reloadRows(at: [indexPath!], with: .fade)
            
        case .move:
            visitTableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    // MARK: controller - didChange section
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
            
        case .insert: visitTableView.insertSections(indexSet, with: .fade)
            
        case .delete: visitTableView.deleteSections(indexSet, with: .fade)
            
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }
    }
    
    // MARK: controllerWillChangeContent
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        visitTableView.beginUpdates()
    }
    
    // MARK: controllerDidChangeContent
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        visitTableView.endUpdates()
    }
}
