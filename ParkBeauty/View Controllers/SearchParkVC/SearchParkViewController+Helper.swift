//
//  SearchParkViewController+Helper.swift
//  ParkBeauty
//
//  Created by Shirley on 6/16/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

// MARK: - SearchParkViewController+Helper (Configure UI)

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

