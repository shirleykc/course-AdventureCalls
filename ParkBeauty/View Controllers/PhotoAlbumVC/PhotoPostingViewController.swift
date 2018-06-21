//
//  PhotoPostingViewController.swift
//  ParkBeauty
//
//  Created by Shirley on 6/20/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import CoreData

class PhotoPostingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties

    var appDelegate: AppDelegate!
    
    
    // The diary being displayed and edited
    
    var photo: Photo!
    var visit: Visit!
    var park: Park!
    
    var dataController:DataController!
    var fetchedPhotoController: NSFetchedResultsController<Photo>!
    
    // A date formatter for the date text
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    // MARK: IBOutlet
    
//    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
//    @IBOutlet weak var topNavbar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
//    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var photoTitleTextField: UITextField!
//    @IBOutlet weak var bottomTextField: UITextField!
    
    // MARK: Life Cycle
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Grab the app delegate */
        appDelegate = UIApplication.shared.delegate as! AppDelegate

        if let aVisit = visit,
            let visitTitle = aVisit.title {
                navigationItem.title = visitTitle
        } else {
                navigationItem.title = "National Park Visit Photos"
        }
        
        // Disable Share Button
        
        shareButton.isEnabled = false
        
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    // MARK: viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Enable Camera Button only if camera is available
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // Hide the top navigation bar and bottom tab bar
//        navigationController?.navigationBar.isHidden = true
//        tabBarController?.tabBar.isHidden = true
        
        // Subscribe to keyboard notifications
        
//        subscribeToKeyboardNotifications()
        
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    // MARK: viewWillDisappear
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
 //       photoTitleTextField.text = ""
        // Unsubscribe from keyboard notifications
        
//        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: imagePickerController Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // If an image is picked, enable Share button and dismiss image picker
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imagePickerView.image = image
            shareButton.isEnabled = true
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: imagePickerControllerDidCancel Delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        shareButton.isEnabled = false
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: subscribeToKeyboardNotifications
    
//    func subscribeToKeyboardNotifications() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
//    }
    
    // MARK: unsubscribeFromKeyboardNotifications
    
//    func unsubscribeFromKeyboardNotifications() {
//        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
//    }
    
    // MARK: keyboardWillShow
    
//    @objc func keyboardWillShow(_ notification: Notification) {
//
//        // If keyboard will show for bottom text field entry, move the view frame up
//
//        if bottomTextField.isFirstResponder {
//            view.frame.origin.y -= getKeyboardHeight(notification)
//        }
//    }
    
    // MARK: keyboardWillHide
    
//    @objc func keyboardWillHide(_ notification: Notification) {
//
//        // Reset the view frame
//
//        view.frame.origin.y = 0
//    }
    
    // MARK: getKeyboardHeight
    
//    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
//        let userInfo = notification.userInfo
//        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
//        return keyboardSize.cgRectValue.height
//    }
    
    // MARK: save
    
    func save() -> Photo {
        let photo = Photo(context: dataController.viewContext)
        if let title = photoTitleTextField.text {
            photo.title = title
        }
        if let photoImage = imagePickerView.image {
            if let data:Data = UIImagePNGRepresentation(photoImage) {
                photo.image = data
            } else if let data:Data = UIImageJPEGRepresentation(photoImage, 1.0) {
                photo.image = data
            }
        }
        photo.visit = visit
        photo.creationDate = Date()
    
        try? dataController.viewContext.save()
        
        return photo
    }
    
    // MARK: configure
    
//    func configure(textField: UITextField, withText text: String) {
//        textField.text = text
////        textField.defaultTextAttributes = memeTextAttributes
//        textField.delegate = memeTextFieldDelegate
//        textField.textAlignment = NSTextAlignment.center
//    }
    
    // MARK: resetPhotoPicker
    
    func resetPhotoPicker() {
//        configure(textField: topTextField, withText: defaultTopText)
//        configure(textField: bottomTextField, withText: defaultBottomText)
        imagePickerView.image = nil
        shareButton.isEnabled = false
    }
    
    // MARK: generateMemedImage
    
//    func generateMemedImage() -> UIImage {
//
//        // hide the bottom and top tool bars before capturing memed image
//
//        bottomToolbar.isHidden = true
//        topNavbar.isHidden = true
//
//        UIGraphicsBeginImageContext(self.view.frame.size)
//        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
//        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//
//        // reset the bottom and top tool bars
//
//        bottomToolbar.isHidden = false
//        topNavbar.isHidden = false
//
//        return memedImage
//    }
    
    // MARK: presentImagePickerWith
    
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: IBAction pickPhotoFromCamera
    
    @IBAction func pickPhotoFromCamera(_ sender: Any) {
        presentImagePickerWith(sourceType: .camera)
    }
    
    // MARK: IBAction pickPhotoFromAlbum
    
    @IBAction func pickPhotoFromAlbum(_ sender: Any) {
        presentImagePickerWith(sourceType: .photoLibrary)
    }
    
    // MARK: IBAction sharePhotoImage
    
    @IBAction func sharePhotoImage(_ sender: Any) {
        
        let photoImage:UIImage = imagePickerView.image!
        let activityViewController = UIActivityViewController(activityItems: [photoImage], applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
        
        // On activity complete, save the photo image and return to the previous state of view controller
        
        activityViewController.completionWithItemsHandler = {
            (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, errors: Error?) -> Void in
            if completed {
                self.photo = self.save()
                self.resetPhotoPicker()
                self.navigationController?.navigationBar.isHidden = false
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: IBAction cancelPhotoImage
    
    @IBAction func cancelPhotoImage(_ sender: Any) {
        resetPhotoPicker()
        navigationController?.navigationBar.isHidden = false
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - PhotoPostingViewController: UITextFieldDelegate

extension PhotoPostingViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
