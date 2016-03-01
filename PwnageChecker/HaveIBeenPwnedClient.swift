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
        static let BreachAccount = "breachedaccount/{account}"
    }
    
    struct UrlKeys {
        static let Account = "account"
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
    
    private func getBreaches(completionHandler: (result: AnyObject!, error: String?)->Void) {
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
    
    func getBreachesForAccount(emailOrUsername : String, completionHandler : (hasBreaches: Bool, result: AnyObject!, error: String?)->Void) {
        
        let escapedValue = emailOrUsername.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let method = HttpClient.subtituteKeyInMethod(Methods.BreachAccount, key: UrlKeys.Account, value: escapedValue)!
        
        HttpClient.sharedInstance().httpGet(BASE_URL, method: method, urlParams: nil, headerParams: nil) {
            (data, code, error) in
            
            guard error == nil else {
                if (code == 404) {
                    completionHandler(hasBreaches: false, result: nil, error: nil)
                }
                else {
                    completionHandler(hasBreaches: false, result: nil, error: error)
                }
                return
            }
            
            HttpClient.parseJSONWithCompletionHandler(data!) {
                (json, parseError) in
                
                guard parseError == nil else {
                    completionHandler(hasBreaches: false, result: nil, error: "Failed to parse response \(parseError)")
                    return
                }
                
                completionHandler(hasBreaches: true, result: json, error: nil)
            }
        }
    }
    
    // refresh breaches in local cache
    func refreshBreachesInBackground()->Void {
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
                    _ = Breach(apiBreachResult: breachItem, context: CoreDataStackManager.sharedInstance().managedObjectContext)
                }
                CoreDataStackManager.sharedInstance().saveContext()
            }
        }
    }
}