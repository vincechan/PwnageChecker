//
//  Breach.swift
//  PwnageChecker
//
//  Created by Vince Chan on 1/16/16.
//  Copyright © 2016 Vince Chan. All rights reserved.
//

import Foundation
import CoreData

/*
* CoreData Managed Object for Breach
*/
class Breach: NSManagedObject {
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(apiBreachResult: AnyObject, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Breach", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        isSensitive = apiBreachResult[Keys.IsSensitive] as? Bool
        name = apiBreachResult[Keys.Name] as? String
        title = apiBreachResult[Keys.Title] as? String
        domain = apiBreachResult[Keys.Domain] as? String
        breachDate = apiBreachResult[Keys.BreachDate] as? String
        addedDate = apiBreachResult[Keys.AddedDate] as? String
        pwnCount = apiBreachResult[Keys.PwnCount] as? Int
        desc = apiBreachResult[Keys.Description] as? String
        dataClasses = apiBreachResult[Keys.DataClasses] as? String
        if dataClasses == nil {
            dataClasses = ""
        }
        isVerified = apiBreachResult[Keys.IsVerified] as? Bool
        logoType = apiBreachResult[Keys.LogoType] as? String
    }
    
    class func deleteAll() {
        let fetchRequest = NSFetchRequest(entityName: "Breach")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try CoreDataStackManager.sharedInstance().persistentStoreCoordinator!.executeRequest(
                deleteRequest,
                withContext: CoreDataStackManager.sharedInstance().managedObjectContext)
        } catch let error as NSError {
            // TODO: error handling
            print("deleteAll error: \(error)")
        }
    }
}


extension Breach {
    struct Keys {
        static let IsSensitive = "IsSensitive"
        static let Name = "Name"
        static let Title = "Title"
        static let Domain = "Domain"
        static let BreachDate = "BreachDate"
        static let AddedDate = "AddedDate"
        static let PwnCount = "PwnCount"
        static let Description = "Description"
        static let DataClasses = "DataClasses"
        static let IsVerified = "IsVerified"
        static let LogoType = "LogoType"
    }
}
