//
//  NPSConstants.swift
//  AdventureCalls
//
//  Created by Shirley on 5/30/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

// MARK: - NPSClient (Constants)

extension NPSClient {
    
    // MARK: NPS Constants
    
    struct NPSConstants {
        
        // MARK: URLs
        
        static let ApiScheme = "https"
        
        // MARK: NPS API
        
        static let ApiHost = "developer.nps.gov"
        static let ApiPath = "/api/v1"
    }
    
    // MARK: Methods
    
    struct Methods {
        
        // MARK: Parks
        
        static let Parks = "/parks"
        
        // MARK: Places
        
        static let Places = "/places"
    }
    
    // MARK: HTTP Header Keys
    
    struct HTTPHeaderKeys {
        
        // MARK: General
        
        static let Accept = "accept"
        static let ContentType = "Content-Type"
    }
    
    // MARK: HTTP Header Values
    
    struct HTTPHeaderValues {
        
        static let APIKey = "7iHhPe84Q6tCtRZQoT8SqhryMWegyH0vUkI1M9Gh"
        static let ApplicationJson = "application/json"
    }
    
    // MARK: NPS Parameter Keys
    
    struct ParameterKeys {
        
        static let APIKey = "api_key"
        static let ParkCode = "parkCode"
        static let StateCode = "stateCode"
        static let Limit = "limit"
        static let Start = "start"
        static let QueryString = "q"
        static let Fields = "fields"
        static let Sort = "sort"
    }
    
    // MARK: NPS Parameter Values
    
    struct ParameterValues {
        
        static let APIKey = "7iHhPe84Q6tCtRZQoT8SqhryMWegyH0vUkI1M9Gh"
        static let PerPage = "50"
    }
    
    // MARK: NPS Response Keys
    
    struct ResponseKeys {
        
        static let Status = "stat"
        static let Total = "total"
        static let Data = "data"
        static let Description = "description"
        static let FullName = "fullName"
        static let Name = "name"
        static let LatLong = "latLong"
        static let Lat = "lat"
        static let Long = "long"
        static let ParkCode = "parkCode"
        static let States = "states"
        static let Url = "url"
        static let Limit = "limit"
        static let Start = "start"
        static let Images = "images"
        static let Title = "title"
        static let ListingImage = "listingImage"
        static let AltText = "altText"
        static let ListingDescription = "listingDescription"
        static let ID = "id"
    }
    
    // MARK: NPS Response Values
    
    struct ResponseValues {
        
        static let OKStatus = "ok"
    }
}
