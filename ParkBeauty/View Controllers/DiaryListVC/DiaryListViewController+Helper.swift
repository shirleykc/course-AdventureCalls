//
//  DiaryListViewController+Helper.swift
//  ParkBeauty
//
//  Created by Shirley on 6/17/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

// MARK: DiaryListViewController+Helper

extension DiaryListViewController {
    
    // MARK: createTopBarButtons - create and set the bar buttons
    
    func createTopBarButtons(_ navigationItem: UINavigationItem) {
        
        var rightButtons: [UIBarButtonItem] = [UIBarButtonItem]()
        let addDiaryButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDiaryPressed))
        rightButtons.append(addDiaryButton)  // 1st button from the right
        rightButtons.append(editButtonItem)  // 2nd button from the right
        navigationItem.setRightBarButtonItems(rightButtons, animated: true)
        
        var leftBarButtons: [UIBarButtonItem] = [UIBarButtonItem]()
        let backButton = UIBarButtonItem(image: UIImage(named: "icon_back-arrow"), style: .plain, target: self, action: #selector(backButtonPressed))
        leftBarButtons.append(backButton)
        navigationItem.setLeftBarButtonItems(leftBarButtons, animated: true)
    }
}
