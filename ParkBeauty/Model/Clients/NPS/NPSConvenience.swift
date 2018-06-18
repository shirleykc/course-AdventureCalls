//
//  NPSConvenience.swift
//  ParkBeauty
//
//  Created by Shirley on 6/7/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

// MARK: - NPSClient (Convenient Resource Methods)

extension NPSClient {
    
    // MARK: getParksFor - query NPS park by park code, state code or keyword
    
    func getParksFor(_ parkCode: String?, _ stateCode: String?, _ keyword: String?, _ start: Int?, completionHandlerForPhotos: @escaping (_ parkCollection: [NPSPark]?, _ nextStart: Int?, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        
        let parameters = [
            NPSClient.ParameterKeys.ParkCode: (parkCode ?? ""),
            NPSClient.ParameterKeys.StateCode: (stateCode ?? ""),
            NPSClient.ParameterKeys.QueryString: (keyword ?? ""),
            NPSClient.ParameterKeys.Start: (start ?? 1),
            NPSClient.ParameterKeys.Limit: NPSClient.ParameterValues.PerPage
            ] as [String : AnyObject]
        
        /* 2. Make the request */
        
        let _ = taskForGETMethod(NPSClient.Methods.Parks, parameters: parameters as [String:AnyObject]) { (results, start, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            
            if let error = error {
                
                completionHandlerForPhotos(nil, nil, error)
            } else {
                /* GUARD: Is the "data" key in dataDictionary? */
                
                guard let parkArray = results else {
                    
                    let userInfo = [NSLocalizedDescriptionKey : "Cannot parse result '\(NPSClient.ResponseKeys.Data)' in \(results)"]
                    completionHandlerForPhotos(nil, nil, NSError(domain: "getParksFor", code: 1, userInfo: userInfo))
                    return
                }
                
                let parkCollection = NPSPark.parksFromResults(parkArray)
                print("parkCollection: \(parkCollection)")
                completionHandlerForPhotos(parkCollection, start, nil)
            }
        }
    }
    
    // MARK: getPlacesFor - query NPS places for park code
    
    func getPlacesFor(_ parkCode: String?, _ start: Int?, completionHandlerForPhotos: @escaping (_ placeCollection: [NPSPlace]?, _ nextStart: Int?, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        
        let parameters = [
            NPSClient.ParameterKeys.ParkCode: (parkCode ?? ""),
            NPSClient.ParameterKeys.Start: (start ?? 1),
            NPSClient.ParameterKeys.Limit: NPSClient.ParameterValues.PerPage
            ] as [String : AnyObject]
        
        /* 2. Make the request */
        
        let _ = taskForGETMethod(NPSClient.Methods.Places, parameters: parameters as [String:AnyObject]) { (results, start, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            
            if let error = error {
                
                completionHandlerForPhotos(nil, nil, error)
            } else {
                
                /* GUARD: Is the "data" key in dataDictionary? */
                
                guard let placeArray = results else {
                    
                    let userInfo = [NSLocalizedDescriptionKey : "Cannot parse result '\(NPSClient.ResponseKeys.Data)' in \(results)"]
                    completionHandlerForPhotos(nil, nil, NSError(domain: "getParksFor", code: 1, userInfo: userInfo))
                    return
                }
                
                let placeCollection = NPSPlace.placesFromResults(placeArray)
                print("placeCollection: \(placeCollection)")
                completionHandlerForPhotos(placeCollection, start, nil)
            }
        }
    }
    
    // MARK: getPlaceImageFrom - get place image data from URL
    
    func getPlaceImageFrom(_ imageUrl: String, completionHandlerForPlaceImage: @escaping (_ data: Data?, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        
        /* 2. Make the request */
        
        let _ = taskForURL(mediumURL: imageUrl) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            
            if let error = error {
                completionHandlerForPlaceImage(nil, error)
            } else {
                completionHandlerForPlaceImage(results, nil)
            }
        }
    }
    
    // MARK: getPhotoImageFrom - get photo image data from URL
    
//    func getPhotoImageFrom(_ mediumURL: String, completionHandlerForPhotoImage: @escaping (_ data: Data?, _ error: NSError?) -> Void) {
//        
//        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
//        
//        /* 2. Make the request */
//        
//        let _ = taskForURL(mediumURL: mediumURL) { (results, error) in
//            
//            /* 3. Send the desired value(s) to completion handler */
//            if let error = error {
//                completionHandlerForPhotoImage(nil, error)
//            } else {
//                completionHandlerForPhotoImage(results, nil)
//            }
//        }
//    }
}
