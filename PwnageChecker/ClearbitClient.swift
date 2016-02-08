//
//  ClearbitClient.swift
//  PwnageChecker
//
//  Created by Vince Chan on 2/4/16.
//  Copyright © 2016 Vince Chan. All rights reserved.
//

import Foundation


class ClearbitClient : NSObject {
    
    let BASE_URL = "https://logo.clearbit.com/"
    
    class func sharedInstance()->ClearbitClient {
        struct Singleton {
            static var sharedInstance = ClearbitClient()
        }
        return Singleton.sharedInstance
    }
    
    
    // get image given a domain

    func getImage(domain: String, completionHandler: (imageData: NSData?, error: String?)->Void) -> Void {
        let imageUrl = BASE_URL + domain
        let url = NSURL(string: imageUrl)!
        let request = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            if let error = downloadError {
                completionHandler(imageData: nil, error: error.localizedDescription)
            } else {
                completionHandler(imageData: data, error: nil)
            }
        }
        task.resume()
    }

}