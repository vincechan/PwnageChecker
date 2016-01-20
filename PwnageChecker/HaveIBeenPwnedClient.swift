//
//  HaveIBeenPwnedClient.swift
//  PwnageChecker
//
//  Created by Vince Chan on 1/16/16.
//  Copyright © 2016 Vince Chan. All rights reserved.
//

import Foundation


extension HaveIBeenPwnedClient {
    struct Methods {
        static let Breaches = "breaches"
    }
}

class HaveIBeenPwnedClient : NSObject {
    
    let BASE_URL = "https://haveibeenpwned.com/api/v2/"
    
    
    class func sharedInstance() -> HaveIBeenPwnedClient {
        struct Singleton {
            static var sharedInstance = HaveIBeenPwnedClient()
        }
        
        return Singleton.sharedInstance
    }
    
    func getBreaches(completionHandler: (result: AnyObject!, error: String?)->Void) {
        
        HttpClient.sharedInstance().httpGet(BASE_URL, method: Methods.Breaches, urlParams: nil, headerParams: nil) {
            (data, code, error) in
            
            guard error == nil else {
                completionHandler(result: nil, error: error)
                return
            }
            
            HttpClient.parseJSONWithCompletionHandler(data!) {
                (json, parseError) in
                
                guard parseError == nil else {
                    completionHandler(result: nil, error: "Failed to parse response \(parseError)")
                    return
                }
                
                completionHandler(result: json, error: nil)
            }
        }
    }
    
    // refresh breaches in local cache
    func refreshBreaches()->Void {
        getBreaches() {
            (result, error) in
            guard (error == nil) else {
                print("refreshBreaches: error \(error)")
                return
            }
            
            guard let breachArray = result as? [[String:AnyObject]] else {
                print("refreshBreaches: no breach result found in response")
                return
            }

            guard breachArray.count > 0 else {
                print("refreshBreaches: no breach result found in response")
                return
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                Breach.deleteAll()
                for breachItem in breachArray {
                    let b = Breach(apiBreachResult: breachItem, context: CoreDataStackManager.sharedInstance().managedObjectContext)
                    print(b)
                }
                CoreDataStackManager.sharedInstance().saveContext()
            }
        }
    }
}