//
//  VisitInfoPostingViewController.swift
//  ParkBeauty
//
//  Created by Shirley on 6/9/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import CoreData

// MARK: VisitInfoPostingViewController

class VisitInfoPostingViewController: UIViewController {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    
    // The park whose visits are being displayed
    var park: Park!
    var visits = [Visit]()
    
    var dataController:DataController!
    
    var fetchedVisitController:NSFetchedResultsController<Visit>!
    
    // Outlets
    
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
    
    // MARK: Life Cycle
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Grab the app delegate
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        setupFetchedVisitController()

        // Set title to park name
        
        if let name = park.fullName {
            self.title = name
        } else {
            self.title = "National Park Visit"
        }
        
        createTopBarButtons()
 //       navigationItem.rightBarButtonItem = editButtonItem
        
        // Add gesture recognizer
        
        addGestureRecognizer()
        
    }
    
    // MARK: viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        setupFetchedVisitController()
    }
    
    // MARK: viewDidDisappear
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        fetchedVisitController = nil
    }
    
    // MARK: - Actions
    
    // MARK: travelDateTextFieldEditing - enable date picker
    
    @IBAction func travelDateTextFieldEditing(_ sender: UITextField) {

        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        sender.becomeFirstResponder()
        
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    // MARK: travelDateTextFieldEndEditing - resign date picker
    
    @IBAction func travelDateTextFieldEndEditing(_ sender: UITextField) {
        
        sender.inputView?.resignFirstResponder()
    }
    
    @IBAction func postVisit(_ sender: Any) {
        
        let visitTitleText = visitTitleTextField.text!
        let visitDateText = visitDateTextField.text!
        if visitTitleText.isEmpty || visitDateText.isEmpty {
            alertTextLabel.text = "Title and/or Travel Date Empty."
        } else {
            if let travelDate = dateFormatter.date(from: visitDateText) {
                setUIEnabled(false)
                
                let rating = ratingControl.selectedSegmentIndex + 1
                addVisit(title: visitTitleText, travelDate: travelDate, rating: Int16(rating))
                
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
    
    // MARK: datePickerValueChanged - format visit date text field
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        visitDateTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
    // MARK: handleTap - tap to end editing
    
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
    
    // MARK: addGestureRecognizer - configure tap and hold recognizer
    
    func addGestureRecognizer() {
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    // MARK: addVisit - Adds a new visit to the data store
    
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
    
    // MARK: textFieldShouldReturn - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
}
