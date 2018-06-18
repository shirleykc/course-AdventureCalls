//
//  VisitInfoPostingViewController+Helper.swift
//  ParkBeauty
//
//  Created by Shirley on 6/17/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

// MARK: VisitInfoPostingViewController+Helper

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
}
