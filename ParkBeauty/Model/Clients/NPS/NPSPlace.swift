//
//  NPSPlace.swift
//  ParkBeauty
//
//  Created by Shirley on 6/6/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

// MARK: - NPSPlace - Places in a National Park

struct NPSPlace {
    
    // MARK: Properties
    
    var id: Int
    var title: String?
    var description: String?
    var placeUrl: String?
    var latLong: String?
    var imageUrl: String?
    var imageAltText: String?
    var latitude: Double?
    var longitude: Double?
    
    // MARK: Initializers
    
    // MARK: init - construct a NPSPlace from a dictionary
    
    init(dictionary: [String:AnyObject]) {
        
        id = dictionary[NPSClient.ResponseKeys.ID] as! Int
        title = dictionary[NPSClient.ResponseKeys.Title] as? String
        description = dictionary[NPSClient.ResponseKeys.ListingDescription] as? String
        placeUrl = dictionary[NPSClient.ResponseKeys.Url] as? String
        latLong = dictionary[NPSClient.ResponseKeys.LatLong] as? String
        imageUrl = dictionary[NPSClient.ResponseKeys.Url] as? String
        imageAltText = dictionary[NPSClient.ResponseKeys.AltText] as? String
    }
    
    // MARK: init - construct a NPSPlace from parameters
    
    init(id: Int, latLong: String?, description: String?, title: String?, url: String?) {
        
        self.id = id
        self.latLong = latLong
        self.description = description
        self.title = title
        self.placeUrl = url
    }

    // MARK: placesFromResults - construct a collection of places from query results
    
    static func placesFromResults(_ results: [AnyObject]) -> [NPSPlace] {

        var places = [NPSPlace]()

        // iterate through array of dictionaries, each Park is a dictionary
        
        for result in results {
            
            // extract latitude and longitude
            
            var latitude: Double?
            var longitude: Double?
            if let latLong = result[NPSClient.ResponseKeys.LatLong] as? String {
                
                let latLongStringArray = latLong.components(separatedBy: ",")
                for item in latLongStringArray {
                    
                    let trimmed = item.trimmingCharacters(in: .whitespacesAndNewlines)
                    if trimmed.hasPrefix("lat") {
                        if let idx = trimmed.index(of: ":") {
                            let aSubstring = trimmed.suffix(from: trimmed.index(after: idx))
                            if let lat = Double(aSubstring)  {
                                latitude = lat
                            }
                        }
                    } else if trimmed.hasPrefix("long") {
                        if let idx = trimmed.index(of: ":") {
                            let aSubstring = trimmed.suffix(from: trimmed.index(after: idx))
                            if let long = Double(aSubstring)  {
                                longitude = long
                            }
                        }
                    }
                }
            }

            // construct a NPSPlace instance
            
            var aPlace = NPSPlace(id: result[NPSClient.ResponseKeys.ID] as! Int,
                latLong: result[NPSClient.ResponseKeys.LatLong] as? String,
                description: result[NPSClient.ResponseKeys.ListingDescription] as? String,
                title: result[NPSClient.ResponseKeys.Title] as? String,
                url: result[NPSClient.ResponseKeys.Url] as? String
            )

            if latitude != nil,
                longitude != nil {
                
                aPlace.latitude = latitude
                aPlace.longitude = longitude
            }
            
            // extract listing images
            
            if let listingImage = result[NPSClient.ResponseKeys.ListingImage] as? [String:AnyObject] {
                
                aPlace.imageAltText = listingImage[NPSClient.ResponseKeys.AltText] as? String
                aPlace.imageUrl = listingImage[NPSClient.ResponseKeys.Url] as? String
            }

            // add to collection
            
            places.append(aPlace)
        }

        return places
    }
}

// MARK: - NPSPlace: Equatable

extension NPSPlace: Equatable {}

func ==(lhs: NPSPlace, rhs: NPSPlace) -> Bool {
    
    return lhs.id == rhs.id
}
