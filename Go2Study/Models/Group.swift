//
//  Group.swift
//  Go2Study
//
//  Created by Ashish Kumar on 01/12/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class Group: NSManagedObject {

    class func insert(dictionary: JSON, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Group {
        let group = NSEntityDescription.insertNewObjectForEntityForName("Group", inManagedObjectContext: managedObjectContext) as! Group
        
        group.id   = dictionary["id"].intValue
        group.name = dictionary["name"].stringValue
        group.desc = dictionary["description"].stringValue
        
        var groupMembers = [User]()
        
        for pcn in dictionary["pcnlist"].arrayValue {
            if let user = User.find(pcn.stringValue, inManagedObjectContext: managedObjectContext) {
                groupMembers.append(user)
            }
        }
        
        group.users = NSSet(array: groupMembers)
        
        return group
    }
    
    class func find(id: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Group? {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Group", inManagedObjectContext: managedObjectContext)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let fetchedObjects = try managedObjectContext.executeFetchRequest(fetchRequest)
            if fetchedObjects.count > 0 {
                return fetchedObjects.first as? Group
            }
        } catch {
            let nserror = error as NSError
            print("Could not find Group \(nserror), \(nserror.userInfo)")
        }
        
        return nil
    }
    
    class func deleteAll(managedObjectContext: NSManagedObjectContext, persistentStoreCoordinator: NSPersistentStoreCoordinator) {
        let fetchRequest = NSFetchRequest(entityName: "Group")
        
        do {
            try persistentStoreCoordinator.executeRequest(NSBatchDeleteRequest(fetchRequest: fetchRequest), withContext: managedObjectContext)
        } catch {
            let nserror = error as NSError
            print("Delete error \(nserror), \(nserror.userInfo)")
        }
    }

}
