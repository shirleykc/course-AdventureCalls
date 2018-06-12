//
//  VisitInfoPostingViewController.swift
//  ParkBeauty
//
//  Created by Shirley on 6/9/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import CoreData

class VisitInfoPostingViewController: UIViewController {
    
    // The park whose visits are being displayed
    var park: Park!
    var visits = [Visit]()
    
    var dataController:DataController!
    
    var fetchedVisitController:NSFetchedResultsController<Visit>!
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var visitTitleTextField: UITextField!
    @IBOutlet weak var visitDateTextField: UITextField!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingControl: UISegmentedControl!
    @IBOutlet weak var postVisitButton: UIButton!
    @IBOutlet weak var alertTextLabel: UILabel!
//    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // A date formatter for date text in note cells
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    func setupFetchedVisitController() {
        
        let fetchRequest:NSFetchRequest<Visit> = Visit.fetchRequest()
        let predicate = NSPredicate(format: "park == %@", argumentArray: [park!])
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = []
        
        fetchedVisitController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
//        fetchedVisitController.delegate = self
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
        setupFetchedVisitController()

        // Set title to park name
        if let name = park.name {
            self.title = name
        } else {
            self.title = "National Park Visit"
        }
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        // Add gesture recognizer
        addGestureRecognizer()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedVisitController()
//        if let indexPath = tableView.indexPathForSelectedRow {
//            tableView.deselectRow(at: indexPath, animated: false)
//            tableView.reloadRows(at: [indexPath], with: .fade)
//        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedVisitController = nil
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Actions
    
    @IBAction func travelDateTextFieldEditing(_ sender: UITextField) {

        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        sender.becomeFirstResponder()
        
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
//    @IBAction func travelDateTextFieldEndEditing(_ sender: UITextField) {
//        
//        sender.inputView?.resignFirstResponder()
//    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        visitDateTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
    // MARK: addGestureRecognizer - configure tap and hold recognizer
    
    func addGestureRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            // handling code
            self.view.endEditing(true)
        }
    }
    
    // MARK: cancelButtonPressed - cancel button is pressed
        
    @objc func cancelButtonPressed() {
            
        navigationController?.popViewController(animated: true)

    }
    
    @IBAction func postVisit(_ sender: Any) {
        
        let visitTitleText = visitTitleTextField.text!
        let visitDateText = visitDateTextField.text!
        if visitTitleText.isEmpty || visitDateText.isEmpty {
            alertTextLabel.text = "Title and/or Travel Date Empty."
        } else {
            if let travelDate = dateFormatter.date(from: visitDateText) {
                setUIEnabled(false)
                
                let visit = addVisit(title: visitTitleText, travelDate: travelDate, rating: Int16(ratingControl.selectedSegmentIndex))
                
                setUIEnabled(true)
                
                // go to next view
                let controller = storyboard!.instantiateViewController(withIdentifier: "VisitListViewController") as! VisitListViewController
                controller.park = park
                controller.dataController = dataController
                navigationController!.pushViewController(controller, animated: true)
            } else {
                alertTextLabel.text = "Travel Date is not valid"
            }
        }
    }
    
    /// Adds a new visit to the end of the `visit` array
    func addVisit(title: String, travelDate: Date, rating: Int16) -> Visit {
        let visit = Visit(context: dataController.viewContext)
        visit.title = title
        visit.travelDate = travelDate
        visit.rating = rating
        visit.creationDate = Date()
        visit.park = park
        print("before save visit: \(visit)")
        try? dataController.viewContext.save()
        
        return visit
    }
    

    
    // -------------------------------------------------------------------------
    // MARK: - Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // If this is a VisitListViewController, we'll configure its `visits`
//        if let vc = segue.destination as? VisitListViewController {
//            if let indexPath = tableView.indexPathForSelectedRow {
//                vc.notebook = fetchedResultsController.object(at: indexPath)
//                vc.dataController = dataController
//            }
//        }
//    }
}

// MARK: - VisitInfoPostingViewController: UITextFieldDelegate

extension VisitInfoPostingViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension VisitInfoPostingViewController {
    
    // MARK: createTopBarButtons - create and set the top bar buttons
    
    func createTopBarButtons() {
        
        var leftBarButtons: [UIBarButtonItem] = [UIBarButtonItem]()
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
        leftBarButtons.append(cancelButton)
        navigationItem.setLeftBarButtonItems(leftBarButtons, animated: true)
//
//        var rightBarButtons: [UIBarButtonItem] = [UIBarButtonItem]()
//        let visitButton = UIBarButtonItem(image: UIImage(named: "icon_travel"), style: .plain, target: self, action: #selector(postVisit))
//        rightBarButtons.append(visitButton)
//        navigationItem.setRightBarButtonItems(rightBarButtons, animated: true)
    }
    
    // MARK: Enable or disable UI
    
    func setUIEnabled(_ enabled: Bool) {
        
        visitTitleTextField.isEnabled = enabled
        visitDateTextField.isEnabled = enabled
        ratingControl.isEnabled = enabled
        visitTitleTextField.text = ""
        alertTextLabel.isEnabled = enabled
        
        // post visit button alpha
        if enabled {
            postVisitButton.alpha = 1.0
        } else {
            postVisitButton.alpha = 0.5
        }
    }
}
