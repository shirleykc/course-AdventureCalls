//
//  DiaryDetailViewController+Helper.swift
//  AdventureCalls
//
//  Created by Shirley on 6/18/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

// MARK: - Toolbar

extension DiaryDetailViewController {
    
    // MARK: presentDeleteDiaryAlert - alert prompt for delete
    
    func presentDeleteDiaryAlert() {
        
        let alert = UIAlertController(title: "Delete Diary", message: "Do you want to delete this diary?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: deleteHandler))
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: deleteHandler - delete the diary note
    
    func deleteHandler(alertAction: UIAlertAction) {
        
        onDelete?()
    }
}
