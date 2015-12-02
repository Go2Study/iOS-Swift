//
//  Group+CoreDataProperties.swift
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

extension Group {

    @NSManaged var name: String?
    @NSManaged var users: NSSet?

}
