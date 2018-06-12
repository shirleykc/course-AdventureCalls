//
//  VisitListViewController.swift
//  ParkBeauty
//
//  Created by Shirley on 6/10/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import CoreData

class VisitListViewController: UIViewController, UITableViewDataSource {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
        
    // The park whose visits are being displayed
    var park: Park!
    var visits = [Visit]()
    
    var dataController:DataController!
    
    var fetchedVisitController:NSFetchedResultsController<Visit>!
    
    // A date formatter for date text in note cells
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    // A table view that displays a list of visits
    @IBOutlet weak var visitTableView: UITableView!
    
    func setupFetchedVisitController() {
        
        let fetchRequest:NSFetchRequest<Visit> = Visit.fetchRequest()
        let predicate = NSPredicate(format: "park == %@", argumentArray: [park!])
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = []
        
        fetchedVisitController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedVisitController.delegate = self
        do {
            try fetchedVisitController.performFetch()
            if let results = fetchedVisitController?.fetchedObjects {
                self.visits = results
            }
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Grab the app delegate
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataController = appDelegate.dataController
        
        // Set title to park name
        if let name = park.name {
            self.title = name
        } else {
            self.title = "National Park Visits"
        }
        
        setupFetchedVisitController()

        createBarButtons(navigationItem)
 //       navigationItem.rightBarButtonItem = editButtonItem
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedVisitController()
        if let indexPath = visitTableView.indexPathForSelectedRow {
            visitTableView.deselectRow(at: indexPath, animated: false)
            visitTableView.reloadRows(at: [indexPath], with: .fade)
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedVisitController = nil
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Actions
    
//    @IBAction func addTapped(sender: Any) {
//        presentNewNotebookAlert()
//    }
    
    // MARK: Add Visit
    
    @objc func addVisitPressed() {
        
        // go to search park view
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
    
    /// Adds a new visit to the end of the `visit` array
    func addVisit(title: String) {
        print("VisitListViewController - addVisit: \(title)")
        let visit = Visit(context: dataController.viewContext)
        visit.title = title
        visit.creationDate = Date()
        try? dataController.viewContext.save()
    }
    
    /// Deletes the visit at the specified index path
    func deleteVisit(at indexPath: IndexPath) {
        let visitToDelete = fetchedVisitController.object(at: indexPath)
        dataController.viewContext.delete(visitToDelete)
        try? dataController.viewContext.save()
    }
    
    func updateEditButtonState() {
        if let sections = fetchedVisitController.sections {
            navigationItem.rightBarButtonItem?.isEnabled = sections[0].numberOfObjects > 0
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        visitTableView.setEditing(editing, animated: animated)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedVisitController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedVisitController.sections?[section].numberOfObjects ?? 0
    }
    
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
        
        

//        if let count = aNotebook.notes?.count {
//            let pageString = count == 1 ? "page" : "pages"
//            cell.pageCountLabel.text = "\(count) \(pageString)"
//        }
        
        return cell
    }
    
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

extension VisitListViewController:NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            visitTableView.insertRows(at: [newIndexPath!], with: .fade)
 //           break
        case .delete:
            visitTableView.deleteRows(at: [indexPath!], with: .fade)
 //           break
        case .update:
            visitTableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            visitTableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: visitTableView.insertSections(indexSet, with: .fade)
        case .delete: visitTableView.deleteSections(indexSet, with: .fade)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        visitTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        visitTableView.endUpdates()
    }
    
}

extension VisitListViewController {
    
    // MARK: createBarButtons - create and set the bar buttons
    
    func createBarButtons(_ navigationItem: UINavigationItem) {
        
        var rightButtons: [UIBarButtonItem] = [UIBarButtonItem]()
        let addVisitButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addVisitPressed))
        rightButtons.append(addVisitButton)  // 1st button from the right
        navigationItem.setRightBarButtonItems(rightButtons, animated: true)
        
        var leftBarButtons: [UIBarButtonItem] = [UIBarButtonItem]()
        let backButton = UIBarButtonItem(image: UIImage(named: "icon_back-arrow"), style: .plain, target: self, action: #selector(backButtonPressed))
        leftBarButtons.append(backButton)
        navigationItem.setLeftBarButtonItems(leftBarButtons, animated: true)
    }
    
//    let fullStarImage:  UIImage = UIImage(named: "starFull.png")!
//    let halfStarImage:  UIImage = UIImage(named: "starHalf.png")!
//    let emptyStarImage: UIImage = UIImage(named: "starEmpty.png")!
//    
//    func getStarImage(starNumber: Double, forRating rating: Double) -> UIImage {
//        if rating >= starNumber {
//            return fullStarImage
//        } else if rating + 0.5 == starNumber {
//            return halfStarImage
//        } else {
//            return emptyStarImage
//        }
//    }
//    
//    if let ourRating = object?["OurRating"] as? Double {
//        cell?.star1.image = getStarImage(1, forRating: ourRating)
//        cell?.star2.image = getStarImage(2, forRating: ourRating)
//        cell?.star3.image = getStarImage(3, forRating: ourRating)
//        cell?.star4.image = getStarImage(4, forRating: ourRating)
//        cell?.star5.image = getStarImage(5, forRating: ourRating)
//    }
//    
//    for (index, imageView) in [cell?.star1, cell?.star2, cell?.star3, cell?.star4, cell?.star5].enumerate() {
//    imageView?.image = getStarImage(index + 1, forRating: ourRating)
//    }
}

