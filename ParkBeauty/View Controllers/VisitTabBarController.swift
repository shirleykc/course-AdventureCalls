//
//  VisitTabBarController.swift
//  ParkBeauty
//
//  Created by Shirley on 6/12/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

// MARK: - VisitTabBarController: UITabBarController

/**
 * This tab bar controller manages the table view and map view of national parks visits.
 */

class VisitTabBarController: UITabBarController {
    
    // MARK: Properties
    
    var refreshButton: UIBarButtonItem?
    var addpinButton: UIBarButtonItem?
    //    var logoutButton: UIBarButtonItem?
    
    var dataController: DataController!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create and set the bar buttons
        createBarButtons(navigationItem)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // create and set the bar buttons
        createBarButtons(navigationItem)
    }
    
    // MARK: createBarButtons - create and set the bar buttons
    
    private func createBarButtons(_ navigationItem: UINavigationItem) {
        
        var rightButtons: [UIBarButtonItem] = [UIBarButtonItem]()
        refreshButton = UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .plain, target: self, action: #selector(refresh))
        addpinButton = UIBarButtonItem(image: UIImage(named: "icon_addpin"), style: .plain, target: self, action: #selector(addpin))
        rightButtons.append(addpinButton!)  // 1st button from the right
        rightButtons.append(refreshButton!) // 2nd buttong from the right
        navigationItem.setRightBarButtonItems(rightButtons, animated: true)
        
        //        var leftButtons: [UIBarButtonItem] = [UIBarButtonItem]()
        //        logoutButton = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logout))
        //        leftButtons.append(logoutButton!)
        //        navigationItem.setLeftBarButtonItems(leftButtons, animated: true)
    }
    
    //    // MARK: Logout
    //
    //    @objc func logout() {
    //        deleteSession()
    //    }
    
    // MARK: Refresh
    
    @objc func refresh() {
        //        refreshStudentInformation()
    }
    
    // MARK: Add Pin
    
    @objc func addpin() {
        
        // go to search park view
        let searchParkViewController = storyboard!.instantiateViewController(withIdentifier: "SearchParkViewController") as! SearchParkViewController
        searchParkViewController.dataController = dataController
        navigationController!.pushViewController(searchParkViewController, animated: true)
    }
}

// MARK: VisitTabBarController

private extension VisitTabBarController {
    
    //    // MARK: Sign Out Udacity
    //
    //    func deleteSession() {
    //
    //        /* start animating */
    //        if let controller = self.selectedViewController as? LocationListViewController {
    //            controller.activityIndicatorView.startAnimating()
    //        } else if let controller = self.selectedViewController as? MapViewController {
    //            controller.activityIndicatorView.startAnimating()
    //        }
    //
    //        UdacityClient.sharedInstance().logoutSession() { (success, errorString) in
    //            performUIUpdatesOnMain {
    //                /* stop animating */
    //                if let controller = self.selectedViewController as? LocationListViewController {
    //                    controller.activityIndicatorView.stopAnimating()
    //                } else if let controller = self.selectedViewController as? MapViewController {
    //                    controller.activityIndicatorView.stopAnimating()
    //                }
    //
    //                if success {
    //                    self.completeSignOut()
    //                } else {
    //                    self.displayError(errorString)
    //                }
    //            }
    //        }
    //    }
    //
    //    // MARK: Refresh Student Information
    //
    //    func refreshStudentInformation() {
    //        UdacityClient.sharedInstance().getStudentLocations { (locations, error) in
    //            if let locations = locations {
    //                if let controller = self.selectedViewController as? LocationListViewController {
    //                    controller.studentLocations.locations = locations
    //                    performUIUpdatesOnMain {
    //                        controller.locationsTableView.reloadData()
    //                    }
    //                } else if let controller = self.selectedViewController as? MapViewController {
    //                    controller.studentLocations.locations = locations
    //                    performUIUpdatesOnMain {
    //                        controller.createAnnotations()
    //
    //                        // center the map on the latest student location
    //                        if let latestLoc = controller.studentLocations.locations!.first {
    //                            controller.centerMapOnStudentLocation(location: latestLoc)
    //                        }
    //                    }
    //                } else {
    //                    print(error ?? "empty error")
    //                }
    //            } else {
    //                print(error ?? "empty error")
    //            }
    //        }
    //    }
    //
    //    // MARK: Complete sign out
    //
    //    func completeSignOut() {
    //
    //        dismiss(animated: true, completion: nil)
    //    }
    
    // MAKR: Display error
    
    func displayError(_ errorString: String?) {
        
        print(errorString!)
        dismiss(animated: true, completion: nil)
    }
}


