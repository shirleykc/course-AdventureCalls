//
//  Constants.swift
//  AdventureCalls
//
//  Created by Shirley on 5/30/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import MapKit

// MARK: AppDelegate

extension AppDelegate {
    
    // MARK: Application constants
    
    struct AppConstants {
        
        // MARK: MapView
        
        static let RegionRadius: CLLocationDistance = 100000  // meters
        
        // MARK: label view
        
        static let MaxNumberOfLines: Int = 5
        
        // MARK: delete button frame size
        
        static let ButtonFrameWidth: CGFloat = 44
        static let ButtonFrameHeight: CGFloat = 44
        
        // MARK: image picker
        
        static let ImagePickerOriginalImageInfoTag = "UIImagePickerControllerOriginalImage"
    }
    
    // MARK: UI
    
    struct UI {
        
        static let LoginColorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).cgColor
        static let LoginColorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).cgColor
        static let GreyColor = UIColor(red: 0.702, green: 0.863, blue: 0.929, alpha:1.0)
        static let BlueColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
    }
}
