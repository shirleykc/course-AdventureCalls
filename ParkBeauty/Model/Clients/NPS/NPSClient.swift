//
//  NPSClient.swift
//  ParkBeauty
//
//  Created by Shirley on 5/30/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

// MARK: - NPSClient: NSObject

class NPSClient : NSObject {
    
    // MARK: Properties
    
    // Search page for NPS photos, default to 1, otherwise a random page number generated from previous search
    static var startRecord: Int?
    
    // shared session
    var session = URLSession.shared
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: NPS GET Method
    
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: [AnyObject]?, _ nextStart: Int?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var parametersWithApiKey = parameters
        parametersWithApiKey[NPSClient.ParameterKeys.APIKey] = NPSClient.ParameterValues.APIKey as AnyObject?
        
        /* 2/3. Build the URL, Configure the request */
        let getMethod: String = method

        let request = NSMutableURLRequest(url: NPSURLFromParameters(parametersWithApiKey, withPathExtension: getMethod))
        request.addValue(NPSClient.HTTPHeaderValues.ApplicationJson, forHTTPHeaderField: NPSClient.HTTPHeaderKeys.Accept)
        request.addValue(NPSClient.HTTPHeaderValues.ApplicationJson, forHTTPHeaderField: NPSClient.HTTPHeaderKeys.ContentType)
        print("request: \(request)")
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            print("response: \(response)")
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: Helper for Creating a URL from Parameters
    
    private func NPSURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = NPSClient.NPSConstants.ApiScheme
        components.host = NPSClient.NPSConstants.ApiHost
        components.path = NPSClient.NPSConstants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    // MARK: given raw JSON, return a usable Foundation object
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: [AnyObject]?, _ nextStart: Int?, _ error: NSError?) -> Void) {
        
        /* parse the data */
        let parsedResult: [String:AnyObject]!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
            return
        }
        print("parsedResult: \(parsedResult)")

        /* GUARD: Is "total" key in the result? */
        guard let totalResults = parsedResult[NPSClient.ResponseKeys.Total] as? Int else {
            let userInfo = [NSLocalizedDescriptionKey : "Cannot find key '\(NPSClient.ResponseKeys.Total)' in \(parsedResult)"]
            completionHandlerForConvertData(nil, nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
            return
        }
        print("totalResults: \(totalResults)")
        
        /* GUARD: Is "limit" key in the result? */
        guard let limit = parsedResult[NPSClient.ResponseKeys.Limit] as? Int else {
            let userInfo = [NSLocalizedDescriptionKey : "Cannot find key '\(NPSClient.ResponseKeys.Limit)' in \(parsedResult)"]
            completionHandlerForConvertData(nil, nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
            return
        }
        print("limit: \(limit)")
        
        /* GUARD: Is "start" key in the result? */
        guard let start = parsedResult[NPSClient.ResponseKeys.Start] as? Int else {
            let userInfo = [NSLocalizedDescriptionKey : "Cannot find key '\(NPSClient.ResponseKeys.Start)' in \(parsedResult)"]
            completionHandlerForConvertData(nil, nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
            return
        }

        
        /* GUARD: Is "data" key in our result? */
        guard let parsedResultArray = parsedResult[NPSClient.ResponseKeys.Data] as? [AnyObject] else {
            let userInfo = [NSLocalizedDescriptionKey : "Cannot find keys '\(NPSClient.ResponseKeys.Data)' in \(parsedResult)"]
            completionHandlerForConvertData(nil, nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
            return
        }
        
        print("parsedResultArray: \(parsedResultArray)")

        let nextStart = start + limit
        if nextStart < totalResults {  // more pages
            completionHandlerForConvertData(parsedResultArray, nextStart, nil)
        }
        else {
            completionHandlerForConvertData(parsedResultArray, nil, nil)
        }
    }
    
    // MARK: Send URL Request to launch place image URL
    
    func taskForURL(mediumURL: String, completionHandlerForURL: @escaping (_ data: Data?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL, Configure the request */
        let imageURL = URL(string: mediumURL)
        let request = URLRequest(url: imageURL! as URL)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForURL(nil, NSError(domain: "taskForURL", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            completionHandlerForURL(data as Data?, nil)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: getPhotoImageFrom - get photo image data from URL
    
    func getPhotoImageFrom(_ mediumURL: String, completionHandlerForPhotoImage: @escaping (_ data: Data?, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        
        /* 2. Make the request */
        let _ = taskForURL(mediumURL: mediumURL) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForPhotoImage(nil, error)
            } else {
                completionHandlerForPhotoImage(results, nil)
            }
        }
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> NPSClient {
        struct Singleton {
            static var sharedInstance = NPSClient()
        }
        return Singleton.sharedInstance
    }
}

