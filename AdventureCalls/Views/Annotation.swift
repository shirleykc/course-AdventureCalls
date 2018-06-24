//
//  Annotation.swift
//  AdventureCalls
//
//  Created by Shirley on 6/1/18.
//  Copyright © 2018 Shirley Chan. All rights reserved.
//

import MapKit

// MARK: Annotation - annotation for the map view

class Annotation: NSObject, MKAnnotation {
    
    // MARK: Properties
    
    var locationCoordinate: CLLocationCoordinate2D
    
    var coordinate: CLLocationCoordinate2D {
        return locationCoordinate
    }
    
    var park: Park?
    var title: String?
    var npsPark: NPSPark?
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: Initializers
    
    init(park: Park) {
        
        self.park = park
        self.locationCoordinate = CLLocationCoordinate2D(latitude: park.latitude, longitude: park.longitude)
        
        let title = park.fullName ?? (park.name ?? "")
        self.title = appDelegate.filterName(title)
    }
    
    init(npsPark: NPSPark) {
        
        self.npsPark = npsPark
        self.locationCoordinate = CLLocationCoordinate2D(latitude: npsPark.latitude!, longitude: npsPark.longitude!)
        
        let title = npsPark.fullName ?? (npsPark.name ?? "")
        self.title = appDelegate.filterName(title)
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
