//
//  AppDelegate.swift
//  ParkBeauty
//
//  Created by Shirley on 5/30/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let dataController = DataController.init(modelName: "ParkBeauty")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        dataController.load()
        
        let navigationController = window?.rootViewController as! UINavigationController
        let parkTabBarController = navigationController.topViewController as! ParkTabBarController
        parkTabBarController.dataController = dataController
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        saveViewContext()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        saveViewContext()
    }
    
    func saveViewContext() {
        try? dataController.viewContext.save()
    }
}

// MARK: Helper methods

extension AppDelegate {
    
    // MARK: Configure background gradient
    
    func configureBackgroundGradient(_ view: UIView) {
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [AppDelegate.UI.GreyColor, AppDelegate.UI.GreyColor]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, at: 0)
    }
    
    // MARK: Configure TextField
    
    func configureTextField(_ textField: UITextField) {
        let textFieldPaddingViewFrame = CGRect(x: 0.0, y: 0.0, width: 13.0, height: 0.0)
        let textFieldPaddingView = UIView(frame: textFieldPaddingViewFrame)
        textField.leftView = textFieldPaddingView
        textField.leftViewMode = .always
        textField.backgroundColor = UIColor.white
        textField.textColor = UIColor.black
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: AppDelegate.UI.GreyColor])
        textField.tintColor = AppDelegate.UI.BlueColor
        textField.borderStyle = .bezel
    }
    
    // MARK: Present application alert
    
    func presentAlert(_ controller: UIViewController, _ errorString: String?) {
        if let errorString = errorString {
            let alert = UIAlertController(title: "Alert", message: errorString, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"Dismiss\" alert occured.")
            }))
            controller.present(alert, animated: true, completion: nil)
        }
    }
    
    func validateURLString(_ urlString: String?, completionHandlerForURL: @escaping (_ success: Bool, _ url: URL?, _ errorString: String?) -> Void) {
        
        if let mediaURL = URL(string: urlString!) {
            completionHandlerForURL(true, mediaURL, nil)
            return
        } else {
            completionHandlerForURL(false, nil, "Invalid URL string \(urlString!)")
            return
        }
    }
}
