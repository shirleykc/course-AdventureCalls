//
//  VisitInfoPostingViewController+Helper.swift
//  AdventureCalls
//
//  Created by Shirley on 6/17/18.
//  Copyright © 2018 Shirley Chan. All rights reserved.
//

import UIKit

// MARK: VisitInfoPostingViewController+Helper

extension VisitInfoPostingViewController {
    
    // MARK: createTopBarButtons - create and set the top bar buttons
    
    func createTopBarButtons() {
        
        var leftBarButtons: [UIBarButtonItem] = [UIBarButtonItem]()
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
        leftBarButtons.append(cancelButton)
        navigationItem.setLeftBarButtonItems(leftBarButtons, animated: true)
    }
    
    // MARK: setUIEnabled - Enable or disable UI
    
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
    
    // MARK: configureUI - Configure UI
    
    func configureUI() {
        
        appDelegate.configureBackgroundGradient(view)
        configureTextField(visitTitleTextField)
        configureTextField(visitDateTextField)
    }
    
    // MARK: configureTextField - Configure text field
    
    func configureTextField(_ textField: UITextField) {
        
        appDelegate.configureTextField(textField)
        textField.delegate = self
    }
}
