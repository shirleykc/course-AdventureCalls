//
//  SearchParkViewController.swift
//  ParkBeauty
//
//  Created by Shirley on 6/1/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import MapKit
//import CoreLocation

// MARK: - SearchParkViewController: UIViewController

/**
 * This view controller presents the search park view
 * to allow users to find national parks.
 */

class SearchParkViewController: UIViewController {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var session: URLSession!
    
    var dataController: DataController!

//    lazy var geocoder = CLGeocoder()
    
    var parkCollection: [NPSPark]!
    
    // MARK: Outlets
    
    @IBOutlet weak var parkCodeTextField: UITextField!
    @IBOutlet weak var stateCodeTextField: UITextField!
    @IBOutlet weak var keywordTextField: UITextField!
    @IBOutlet weak var findParkButton: BorderedButton!
    @IBOutlet weak var alertTextLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Grab the app delegate */
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        navigationItem.title = "Add National Parks"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(cancelAdd))
        
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        parkCodeTextField.text = ""
        stateCodeTextField.text = ""
        keywordTextField.text = ""
        alertTextLabel.text = ""
        setUIEnabled(true)
    }
    
    // MARK: Cancel Add Location
    
    @objc func cancelAdd() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Find Park
    
    @IBAction func findParkPressed(_ sender: AnyObject) {
        
        // Update View
        setUIEnabled(false)
        
        activityIndicatorView.startAnimating()
        searchParksFor(parkCodeTextField.text, stateCodeTextField.text, keywordTextField.text, 1) { (success, results, errorString) in
            performUIUpdatesOnMain {
                self.activityIndicatorView.stopAnimating()
                if success {
                    print("results: \(results)")
                    if let results = results,
                        results.count > 0 {
                        self.completeParkSearching(results)
                        
                        // center the map on the latest student location
//                        if let latestLoc = self.studentLocations.locations!.first {
//                            self.centerMapOnStudentLocation(location: latestLoc)
//                        }
                    } else {
                        self.displayError("No parks found!")
                    }
                } else {
                    self.displayError(errorString)
                }
            }
        }
    }
    
    // MARK: searchParksFor - search NPS parks for parkCode, stateCode and/or keyword
    
    func searchParksFor(_ parkCode: String?, _ stateCode: String?, _ keyword: String?, _ start: Int?, completionHandlerForSearchParks: @escaping (_ success: Bool, _ result: [NPSPark]?, _ error: String?) -> Void) {
        
        NPSClient.sharedInstance().getParksFor(parkCode, stateCode, keyword, start) { (results, nextStart, error) in
            
            guard (error == nil) else {
                completionHandlerForSearchParks(false, nil, (error?.userInfo[NSLocalizedDescriptionKey] as! String))
                return
            }
            
            performUIUpdatesOnMain {
                if let results = results {
                    completionHandlerForSearchParks(true, results, nil)
                } else {
                    completionHandlerForSearchParks(false, nil, "Cannot load parks")
                }
            }
        }
    }
    
    // MARK: Complete parks searching
    
    private func completeParkSearching(_ results: [NPSPark]) {
        setUIEnabled(true)
        
        // go to next view
        let controller = storyboard!.instantiateViewController(withIdentifier: "ParkInfoPostingViewController") as! ParkInfoPostingViewController
//        controller.place = place
//        controller.mediaURL = mediaURLTextField.text!
        controller.parkCollection = results
        controller.dataController = dataController
        navigationController!.pushViewController(controller, animated: true)
    }
}

// MARK: - InfoPostingViewController: UITextFieldDelegate

extension SearchParkViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - InfoPostingViewController (Configure UI)

extension SearchParkViewController {
    
    // MARK: Enable or disable UI
    
    func setUIEnabled(_ enabled: Bool) {
        parkCodeTextField.isEnabled = enabled
        stateCodeTextField.isEnabled = enabled
        keywordTextField.isEnabled = enabled
        findParkButton.isEnabled = enabled
        alertTextLabel.text = ""
        alertTextLabel.isEnabled = enabled
        
        // adjust find location button alpha
        if enabled {
            findParkButton.alpha = 1.0
        } else {
            findParkButton.alpha = 0.5
        }
    }
    
    // MARK: Display error
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            setUIEnabled(true)
            alertTextLabel.text = errorString
            alertTextLabel.textColor = UIColor.red
        }
    }
    
    // MARK: Configure UI
    
    func configureUI() {
        appDelegate.configureBackgroundGradient(view)
        configureTextField(parkCodeTextField)
        configureTextField(stateCodeTextField)
        configureTextField(keywordTextField)
        activityIndicatorView.stopAnimating()
    }
    
    // MARK: Configure text field
    
    func configureTextField(_ textField: UITextField) {
        appDelegate.configureTextField(textField)
        textField.delegate = self
    }
}
