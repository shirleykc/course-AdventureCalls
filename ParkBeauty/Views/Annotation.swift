//
//  Annotation.swift
//  ParkBeauty
//
//  Created by Shirley on 6/1/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import MapKit

// MARK: Annotation

class Annotation: NSObject, MKAnnotation {
    
    // MARK: Properties
    
    var locationCoordinate: CLLocationCoordinate2D
    
    var coordinate: CLLocationCoordinate2D {
        return locationCoordinate
    }
    
    var park: Park?
    var title: String?
    
    // MARK: Initializers
    
    init(park: Park) {
        self.park = park
        self.locationCoordinate = CLLocationCoordinate2D(latitude: park.latitude, longitude: park.longitude)
        self.title = park.fullName ?? (park.name ?? "")
    }
    
    init(locationCoordinate: CLLocationCoordinate2D) {
        self.locationCoordinate = locationCoordinate
    }
    
    // MARK: Class Functions
    public func updateCoordinate(newLocationCoordinate: CLLocationCoordinate2D) -> Void {
        
        // Update location coordinate from old to new
        willChangeValue(forKey: "coordinate")
        locationCoordinate = newLocationCoordinate
        didChangeValue(forKey: "coordinate")
    }
}
