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
    
    // A closure that is run when the user asks to delete the current note
    
    var onDelete: (() -> Void)?
    
    // A date formatter for the date text
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    // MARK: IBOutlets
    
    // A text view that displays a diary's note text
    
    @IBOutlet weak var diaryNoteTextView: UITextView!
    
    // MARK: Life Cycle
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /* Grab the app delegate */
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if let aDiary = diary {
            if let diaryTitle = aDiary.title {
                navigationItem.title = diaryTitle
            }
            
            if let diaryNote = aDiary.note {
                diaryNoteTextView.text = diaryNote
            }
        }
    }
    
    // MARK: Actions
    
    // MARK: deleteDiary
    
    @IBAction func deleteDiary() {
        
        presentDeleteDiaryAlert()
    }
    
    // MARK: backButtonPressed - back button is pressed
    
    @IBAction func saveButtonPressed() {
        
        saveNoteFor(diary, diaryNoteTextView)
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: saveNoteFor - save note to data store
    
    private func saveNoteFor(_ diary: Diary, _ textView: UITextView) {
        
        diary.note = textView.text
        
        try? dataController.viewContext.save()
    }
}
