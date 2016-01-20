//
//  Breach+CoreDataProperties.swift
//  PwnageChecker
//
//  Created by Vince Chan on 1/16/16.
//  Copyright © 2016 Vince Chan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Breach {

    @NSManaged var isSensitive: NSNumber?
    @NSManaged var name: String?
    @NSManaged var title: String?
    @NSManaged var domain: String?
    @NSManaged var breachDate: String?
    @NSManaged var addedDate: String?
    @NSManaged var pwnCount: NSNumber?
    @NSManaged var desc: String?
    @NSManaged var dataClasses: String?
    @NSManaged var isVerified: NSNumber?
    @NSManaged var logoType: String?

}
