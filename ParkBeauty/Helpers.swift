//
//  Helpers.swift
//  ParkBeauty
//
//  Created by Shirley on 6/17/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

// MARK: AppDelegate Helper methods

extension AppDelegate {
    
    // MARK: configureBackgroundGradient - Configure background gradient
    
    func configureBackgroundGradient(_ view: UIView) {
        
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [AppDelegate.UI.GreyColor, AppDelegate.UI.GreyColor]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, at: 0)
    }
    
    // MARK: configureTextField - Configure TextField
    
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
    
    // MARK: presentAlert - Present application alert
    
    func presentAlert(_ controller: UIViewController, _ errorString: String?) {
        
        if let errorString = errorString {
            
            let alert = UIAlertController(title: "Alert", message: errorString, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"Dismiss\" alert occured.")
            }))
            
            controller.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: validateURLString
    
    func validateURLString(_ urlString: String?, completionHandlerForURL: @escaping (_ success: Bool, _ url: URL?, _ errorString: String?) -> Void) {
        
        if let mediaURL = URL(string: urlString!) {
            completionHandlerForURL(true, mediaURL, nil)
            return
        } else {
            completionHandlerForURL(false, nil, "Invalid URL string \(urlString!)")
            return
        }
    }
    
    // MARK: filterName
    
    func filterName(_ name: String?) -> String {
        
        if let name = name {
            
            let aName: NSMutableString = NSMutableString(string: name)
            let pattern = "(&#)(\\d{3,})(;)"
            let regex = try? NSRegularExpression(pattern: pattern)
            regex?.replaceMatches(in: aName , options: .reportProgress , range: NSRange(location: 0,length: aName.length), withTemplate: "")
            
            return String(aName)
        } else {
            
            return ""
        }
    }
}
