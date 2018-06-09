//
//  NPSPark.swift
//  ParkBeauty
//
//  Created by Shirley on 5/31/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

// MARK: - NPSPark

struct NPSPark {
    
    // MARK: Properties
    
    var parkCode: String
    var states: String?
    var latLong: String?
    var description: String?
    var fullName: String?
    var name: String?
    var url: String?
    var latitude: Double?
    var longitude: Double?
    
    // MARK: Initializers
    
    // construct a NPSPark from a dictionary
    init(dictionary: [String:AnyObject]) {
        parkCode = dictionary[NPSClient.ResponseKeys.ParkCode] as! String
        states = dictionary[NPSClient.ResponseKeys.States] as? String
        latLong = dictionary[NPSClient.ResponseKeys.LatLong] as? String
        description = dictionary[NPSClient.ResponseKeys.Description] as? String
        fullName = dictionary[NPSClient.ResponseKeys.FullName] as? String
        name = dictionary[NPSClient.ResponseKeys.Name] as? String
        url = dictionary[NPSClient.ResponseKeys.Url] as? String
    }
    
    init(parkCode: String,
         states: String?,
         latLong: String?,
         description: String?,
         fullName: String?,
         name: String?,
         url: String?) {
        self.parkCode = parkCode
        self.states = states
        self.latLong = latLong
        self.description = description
        self.fullName = fullName
        self.name = name
        self.url = url
    }
    
    init(parkCode: String,
         states: String?,
         latLong: String?,
         description: String?,
         fullName: String?,
         name: String?,
         url: String?,
         latitude: Double?,
         longitude: Double?) {
        self.parkCode = parkCode
        self.states = states
        self.latLong = latLong
        self.description = description
        self.fullName = fullName
        self.name = name
        self.url = url
        self.latitude = latitude
        self.longitude = longitude
    }
    
    static func parksFromResults(_ results: [[String:AnyObject]]) -> [NPSPark] {
        
        var parks = [NPSPark]()
        
        // iterate through array of dictionaries, each Park is a dictionary
        for result in results {
            parks.append(NPSPark(dictionary: result))
        }
        
        return parks
    }
    
    static func parksFromResults(_ results: [AnyObject]) -> [NPSPark] {
        
        var parks = [NPSPark]()
        
        // iterate through array of dictionaries, each Park is a dictionary
        for result in results {
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
            
            var aPark = NPSPark(parkCode: result[NPSClient.ResponseKeys.ParkCode] as! String,
                states: result[NPSClient.ResponseKeys.States] as? String,
                latLong: result[NPSClient.ResponseKeys.LatLong] as? String,
                description: result[NPSClient.ResponseKeys.Description] as? String,
                fullName: result[NPSClient.ResponseKeys.FullName] as? String,
                name: result[NPSClient.ResponseKeys.Name] as? String,
                url: result[NPSClient.ResponseKeys.Url] as? String
            )
            
            if latitude != nil,
                longitude != nil {
                aPark.latitude = latitude
                aPark.longitude = longitude
            }

            parks.append(aPark)
        }
        
        return parks
    }
}

// MARK: - NPSPark: Equatable

extension NPSPark: Equatable {}

func ==(lhs: NPSPark, rhs: NPSPark) -> Bool {
    return lhs.parkCode == rhs.parkCode
}

