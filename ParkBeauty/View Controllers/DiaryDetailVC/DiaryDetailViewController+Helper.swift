//
//  DiaryDetailViewController+Helper.swift
//  ParkBeauty
//
//  Created by Shirley on 6/18/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

// MARK: - Toolbar

extension DiaryDetailViewController {
    
    // MARK: createTopBarButtons - create and set the bar buttons
    
    func createTopBarButtons(_ navigationItem: UINavigationItem) {
        
        var rightButtons: [UIBarButtonItem] = [UIBarButtonItem]()
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteDiary(sender:)))
        rightButtons.append(trashButton)  // 1st button from the right
        navigationItem.setRightBarButtonItems(rightButtons, animated: true)
        
        var leftBarButtons: [UIBarButtonItem] = [UIBarButtonItem]()
        let backButton = UIBarButtonItem(image: UIImage(named: "icon_back-arrow"), style: .plain, target: self, action: #selector(backButtonPressed))
        leftBarButtons.append(backButton)
        navigationItem.setLeftBarButtonItems(leftBarButtons, animated: true)
    }
    
    // MARK: showDeleteAlert - show delete alert
    
    func showDeleteAlert() {
        let alert = UIAlertController(title: "Delete Diary?", message: "Are you sure you want to delete the current diary?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.onDelete?()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }
    
    /// Returns an array of toolbar items. Used to configure the view controller's
    /// `toolbarItems' property, and to configure an accessory view for the
    /// text view's keyboard that also displays these items.
//    func makeToolbarItems() -> [UIBarButtonItem] {
//        let trash = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTapped(sender:)))
//        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let bold = UIBarButtonItem(image: #imageLiteral(resourceName: "toolbar-bold"), style: .plain, target: self, action: #selector(boldTapped(sender:)))
//        let red = UIBarButtonItem(image: #imageLiteral(resourceName: "toolbar-underline"), style: .plain, target: self, action: #selector(redTapped(sender:)))
//        let cow = UIBarButtonItem(image: #imageLiteral(resourceName: "toolbar-cow"), style: .plain, target: self, action: #selector(cowTapped(sender:)))
//        
//        return [space, trash, space, bold, space, red, space, cow, space]
//    }
//    
//    /// Configure the current toolbar
//    func configureToolbarItems() {
//        toolbarItems = makeToolbarItems()
//        navigationController?.setToolbarHidden(false, animated: false)
//    }
}
