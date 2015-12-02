//
//  User+CoreDataProperties.swift
//  Go2Study
//
//  Created by Ashish Kumar on 01/12/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var department: String?
    @NSManaged var displayName: String?
    @NSManaged var firstName: String?
    @NSManaged var initials: String?
    @NSManaged var lastName: String?
    @NSManaged var mail: String?
    @NSManaged var office: String?
    @NSManaged var pcn: String?
    @NSManaged var phone: String?
    @NSManaged var photo: NSData?
    @NSManaged var title: String?
    @NSManaged var type: String?
    @NSManaged var groups: NSSet?

}
