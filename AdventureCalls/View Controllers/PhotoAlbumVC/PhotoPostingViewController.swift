//
//  PhotoPostingViewController.swift
//  AdventureCalls
//
//  Created by Shirley on 6/20/18.
//  Copyright © 2018 Shirley Chan. All rights reserved.
//

import UIKit
import CoreData

// MARK: PhotoPostingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate - to present the image picker

class PhotoPostingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties

    var appDelegate: AppDelegate!
    
    // The photo being displayed
    
    var photo: Photo!
    var visit: Visit!
    var park: Park!
    
    var dataController:DataController!
    var fetchedPhotoController: NSFetchedResultsController<Photo>!
    
    var imageOrientation: UIImageOrientation!
    
    // A date formatter for the date text
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    // MARK: IBOutlet
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var photoTitleTextField: UITextField!
    
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
        saveButton.isEnabled = false
        
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    // MARK: viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Enable Camera Button only if camera is available
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    // MARK: viewWillDisappear
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        // reset
        
        fetchedPhotoController = nil
    }
    
    // MARK: imagePickerController - didFinishPickingMediaWithInfo Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // If an image is picked, enable Share button and dismiss image picker
        
        if let image = info[AppDelegate.AppConstants.ImagePickerOriginalImageInfoTag] as? UIImage {
            imageOrientation = image.imageOrientation
            imagePickerView.image = image

            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: imagePickerControllerDidCancel Delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        shareButton.isEnabled = false
        saveButton.isEnabled = false
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: save - save photo image data to data store
    
    func save() -> Photo {
        
        let photo = Photo(context: dataController.viewContext)
        
        if let title = photoTitleTextField.text {
            
            photo.title = title
        }
        
        if let photoImage = imagePickerView.image {
            
            var data: Data?

            if let cgImage = photoImage.cgImage {
                
                // include image orientation when converting to image data
                
                let orientedImage = UIImage(cgImage: cgImage, scale: photoImage.scale, orientation: photoImage.imageOrientation)
            
                data = UIImageJPEGRepresentation(orientedImage, 0.8)
            }
            else {
                
                data = UIImagePNGRepresentation(photoImage)
            }
            photo.image = data
        }

        photo.visit = visit
        photo.creationDate = Date()
    
        try? dataController.viewContext.save()
        
        return photo
    }
    
    // MARK: resetPhotoPicker
    
    func resetPhotoPicker() {
        
        imagePickerView.image = nil
        shareButton.isEnabled = false
        saveButton.isEnabled = false
    }
    
    // MARK: presentImagePickerWith
    
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        
        shareButton.isEnabled = true
        saveButton.isEnabled = true
        
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
    
    // MARK: IBAction savePhotoImage
    
    @IBAction func savePhotoImage(_ sender: Any) {
        
        photo = self.save()
        resetPhotoPicker()
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.popViewController(animated: true)
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
    
    // MARK: textFieldShouldReturn - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
