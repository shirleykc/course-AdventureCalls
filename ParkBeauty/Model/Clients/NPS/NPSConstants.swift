//
//  NPSConstants.swift
//  ParkBeauty
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
        
        static let SearchBBoxHalfWidth = 1.0
        static let SearchBBoxHalfHeight = 1.0
        static let SearchLatRange = (-90.0, 90.0)
        static let SearchLonRange = (-180.0, 180.0)
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
        
//        // MARK: Udacity Parse API header keys
//        static let ParseApplicationId = "X-Parse-Application-Id"
//        static let ParseRESTAPIKey = "X-Parse-REST-API-Key"
        
        // MARK: General
        static let Accept = "accept"
//        static let Authorization = "Authorization"
        static let ContentType = "Content-Type"
//
//        // MARK: Cookies
//        static let XsrfToken = "X-XSRF-TOKEN"
    }
    
    // MARK: HTTP Header Values
    
    struct HTTPHeaderValues {
//        static let ParseApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
//        static let ParseApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
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
