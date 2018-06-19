//
//  DiaryDetailViewController.swift
//  ParkBeauty
//
//  Created by Shirley on 6/17/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import CoreData

// MARK: DiaryDetailViewController

class DiaryDetailViewController: UIViewController {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!

    
    // The diary being displayed and edited
    
    var diary: Diary!
    var visit: Visit!
    var park: Park!
    
    var dataController:DataController!
    var fetchedDiaryController: NSFetchedResultsController<Diary>!

    var saveObserverToken: Any?
    
    // A closure that is run when the user asks to delete the current note
    
    var onDelete: (() -> Void)?
    
    // A date formatter for the date text
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    // The accessory view used when displaying the keyboard
    //var keyboardToolbar: UIToolbar?
    
    // MARK: IBOutlets
    
    // A text view that displays a diary's note text
    
    @IBOutlet weak var diaryNoteTextView: UITextView!
    @IBOutlet weak var diaryTitleText: UITextField!
    
    // MARK: Life Cycle
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /* Grab the app delegate */
        appDelegate = UIApplication.shared.delegate as! AppDelegate

        if let travelDate = visit.travelDate {
            navigationItem.title = dateFormatter.string(from: travelDate)
        }
        
        if let aDiary = diary {
            if let diaryTitle = aDiary.title {
                diaryTitleText.text = diaryTitle
            }
            
            if let diaryNote = aDiary.note {
                diaryNoteTextView.text = diaryNote
            }
        }
        
//        createTopBarButtons(navigationItem)
        
        // keyboard toolbar configuration
//        configureToolbarItems()
//        configureTextViewInputAccessoryView()
        
        addSaveNotificationObserver()
    }
    
    deinit {
        removeSaveNotificationObserver()
    }
    
    // MARK: Actions
    
    // MARK: deleteDiary
    
    @IBAction func deleteDiary(sender: Any) {
        
        presentDeleteDiaryAlert()
    }
    
    // MARK: backButtonPressed - back button is pressed
    
    @IBAction func backButtonPressed() {
        
        navigationController?.popViewController(animated: true)
    }
}

// MARK: DiaryDetailViewController - Editing

extension DiaryDetailViewController {
    
    // MARK: presentDeleteDiaryAlert
    
    func presentDeleteDiaryAlert() {
        
        let alert = UIAlertController(title: "Delete Diary", message: "Do you want to delete this diary?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: deleteHandler))
        present(alert, animated: true, completion: nil)
    }
    
    func deleteHandler(alertAction: UIAlertAction) {
        onDelete?()
    }
}

// MARK: DiaryDetailViewController: UITextViewDelegate

extension DiaryDetailViewController: UITextViewDelegate {
    
    // MARK: textViewDidEndEditing
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
//        let diary = Diary(context: dataController.viewContext)
        diary.note = textView.text
        diary.title = diaryTitleText?.text
//        diary.visit = visit
//        diary.creationDate = Date()
        
        try? dataController.viewContext.save()
    }
}

// MARK: DiaryDetailViewController - Helpers for 

extension DiaryDetailViewController {
    
    // MARK: addSaveNotificationObserver
    
    func addSaveNotificationObserver() {
        
        removeSaveNotificationObserver()
        saveObserverToken = NotificationCenter.default.addObserver(forName: .NSManagedObjectContextObjectsDidChange, object: dataController?.viewContext, queue: nil, using: handleSaveNotification(notification:))
    }
    
    // MARK: removeSaveNotificationObserver
    
    func removeSaveNotificationObserver() {
        
        if let token = saveObserverToken {
            
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    // MARK: reloadText
    
    fileprivate func reloadText() {
        
        if let aDiary = diary {
            diaryTitleText.text = aDiary.title
            diaryNoteTextView.text = aDiary.note
        }
    }
    
    // MARK: handleSaveNotification
    
    func handleSaveNotification(notification:Notification) {
        
        DispatchQueue.main.async {
            
            self.reloadText()
        }
    }
}
