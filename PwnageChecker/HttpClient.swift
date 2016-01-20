//
//  HttpClient.swift
//  PwnageChecker
//
//  Created by Vince Chan on 1/18/16.
//  Copyright © 2016 Vince Chan. All rights reserved.
//

import Foundation

/*
 * Provide helper functions for HTTP operations
 */
class HttpClient: NSObject {
    
    var session: NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // Perform a HTTP GET operation
    func httpGet(baseUrl: String, method: String, urlParams: [String:AnyObject]?, headerParams: [String:AnyObject]?, completionHandler: (result: NSData?, code: Int?, error: String?) -> Void) {
        
        let urlString = baseUrl + method + HttpClient.escapeParameters(urlParams)
        
        guard let url = NSURL(string: urlString) else {
            completionHandler(result: nil, code: nil, error: "Bad url \(urlString)")
            return
        }
        
        let request = NSMutableURLRequest(URL: url)
        HttpClient.addHeaderParameters(request, headerParams: headerParams)
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) in
            
            // ensure no error
            guard (error == nil) else {
                completionHandler(result: nil, code: nil, error: error!.localizedDescription)
                return
            }
            
            // ensure we receive a 2xx HTTP status code
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    completionHandler(result: nil, code: response.statusCode, error: "Invalid response. Status code: \(response.statusCode)")
                } else if let response = response {
                    completionHandler(result: nil, code: nil, error: "Invalid response. \(response)")
                } else {
                    completionHandler(result: nil, code: nil, error: "Invalid response.")
                }
                return
            }
            
            // ensure we receive data
            guard let data = data else {
                completionHandler(result: nil, code: statusCode, error: "No data returned")
                return
            }
            
            completionHandler(result: data, code: statusCode, error: nil)
        }
        
        // Start the request
        task.resume()
    }
    
    // Perform a HTTP POST operation
    func httpPost(baseUrl: String, method: String, urlParams: [String:AnyObject]?, headerParams: [String:AnyObject]?, jsonBody: [String:AnyObject], completionHandler: (result: NSData?, code: Int?, error: String?) -> Void) {
        
        let urlString = baseUrl + method + HttpClient.escapeParameters(urlParams)
        guard let url = NSURL(string: urlString) else {
            completionHandler(result: nil, code: nil, error: "Bad url \(urlString)")
            return
        }
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        HttpClient.addHeaderParameters(request, headerParams: headerParams)
        
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) in
            
            // ensure no error
            guard (error == nil) else {
                completionHandler(result: nil, code: nil, error: error!.localizedDescription)
                return
            }
            
            // ensure we receive a successful 2xx status code reponse
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    completionHandler(result: nil, code: response.statusCode, error: "Invalid response. Status code: \(response.statusCode)")
                } else if let response = response {
                    completionHandler(result: nil, code: nil, error: "Invalid response. \(response)")
                } else {
                    completionHandler(result: nil, code: nil, error: "Invalid response.")
                }
                return
            }
            
            // ensure we receive data
            guard let data = data else {
                completionHandler(result: nil, code: statusCode, error: "No data returned")
                return
            }
            
            completionHandler(result: data, code: statusCode, error: nil)
        }
        
        // start the request
        task.resume()
    }
    
    // Perform a HTTP PUT operation
    func httpPut(baseUrl: String, method: String, urlParams: [String:AnyObject]?, headerParams: [String:AnyObject]?, jsonBody: [String:AnyObject], completionHandler: (result: NSData?, code: Int?, error: String?) -> Void) {
        
        let urlString = baseUrl + method + HttpClient.escapeParameters(urlParams)
        guard let url = NSURL(string: urlString) else {
            completionHandler(result: nil, code: nil, error: "bad url \(urlString)")
            return
        }
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        HttpClient.addHeaderParameters(request, headerParams: headerParams)
        
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) in
            
            // ensure no error
            guard (error == nil) else {
                completionHandler(result: nil, code: nil, error: error!.localizedDescription)
                return
            }
            
            // ensure we receive a successful 2xx status code reponse
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    completionHandler(result: nil, code: response.statusCode, error: "Invalid response. Status code: \(response.statusCode)")
                } else if let response = response {
                    completionHandler(result: nil, code: nil, error: "Invalid response. \(response)")
                } else {
                    completionHandler(result: nil, code: nil, error: "Invalid response.")
                }
                return
            }

            
            // ensure we receive data
            guard let data = data else {
                completionHandler(result: nil, code: statusCode, error: "No data returned")
                return
            }
            
            completionHandler(result: data, code: statusCode, error: nil)
        }
        
        // start the request
        task.resume()
    }
    
    // Substitute the key for the value that is contained within the method name
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    // Given raw JSON, return a usable Foundation object
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: String?) -> Void) {
        var parsedResult: AnyObject!
        
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            completionHandler(result: nil, error: "Could not parse the data as JSON: '\(data)'")
            return
        }
        
        completionHandler(result: parsedResult, error: nil)
    }
    
    // Given a dictionary of parameters, convert to a string for a url
    class func escapeParameters(parameters: [String : AnyObject]?) -> String {
        if let parameters = parameters {
            
            var urlVars = [String]()
            
            for (key, value) in parameters {
                // Make sure that it is a string value
                let stringValue = "\(value)"
                
                // Escape it
                let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                
                // Append it
                urlVars += [key + "=" + "\(escapedValue!)"]
            }
            
            return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
        }
        return ""
    }
    
    // Given a dictionary of parameters, add the parameters to the request header
    class func addHeaderParameters(request: NSMutableURLRequest, headerParams: [String:AnyObject]?) {
        if let headerParams = headerParams {
            for (key, value) in headerParams {
                let stringValue = "\(value)"
                request.addValue(stringValue, forHTTPHeaderField: key)
            }
        }
    }
    
    class func sharedInstance() -> HttpClient {
        struct Singleton {
            static var sharedInstance = HttpClient()
        }
        
        return Singleton.sharedInstance
    }
    
}
