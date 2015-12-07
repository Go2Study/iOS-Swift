//
//  User.swift
//  Go2Study
//
//  Created by Ashish Kumar on 29/11/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON


class User: NSManagedObject {

    class func insertStudent(dictionary: JSON, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> User {
        let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: managedObjectContext) as! User
        
        user.firstName   = dictionary["firstName"].stringValue
        user.lastName    = dictionary["lastName"].stringValue
        user.displayName = dictionary["displayName"].stringValue
        user.mail        = dictionary["email"].stringValue
        user.pcn         = dictionary["pcn"].stringValue
        user.type        = "student"
        user.photo       = NSData(base64EncodedString: dictionary["photo"].stringValue, options: .IgnoreUnknownCharacters)
        
        return user
    }
    
    class func insertStaff(dictionary: JSON, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> User {
        let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: managedObjectContext) as! User
        
        user.firstName     = dictionary["givenName"].stringValue
        user.lastName      = dictionary["surName"].stringValue
        user.displayName   = dictionary["displayName"].stringValue
        user.initials      = dictionary["initials"].stringValue
        user.mail          = dictionary["mail"].stringValue
        user.office        = dictionary["office"].stringValue
        user.phone         = dictionary["telephoneNumber"].stringValue
        user.pcn           = dictionary["id"].stringValue
        user.title         = dictionary["title"].stringValue
        user.department    = dictionary["department"].stringValue
        user.type          = "staff"
        user.photo         = NSData(base64EncodedString: dictionary["thumbnailData"].stringValue, options: .IgnoreUnknownCharacters)
        user.personalTitle = dictionary["personalTitle"].stringValue
        
        return user
    }
    
    class func find(pcn: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> User? {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedObjectContext)
        fetchRequest.predicate = NSPredicate(format: "pcn == %@", pcn)
        do {
            let fetchedObjects = try managedObjectContext.executeFetchRequest(fetchRequest)
            if fetchedObjects.count > 0 {
                return fetchedObjects.first as? User
            }
        } catch {
            let nserror = error as NSError
            print("Could not find User \(nserror), \(nserror.userInfo)")
        }
        
        return nil
    }
    
    class func savePhoto(photo: NSData, forPCN pcn: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) {
        let user = find(pcn, inManagedObjectContext: managedObjectContext)
        user?.photo = photo
    }
    
    class func deleteAll(type: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext, persistentStoreCoordinator: NSPersistentStoreCoordinator) {
        let fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "type == %@", type)
        
        do {
            try persistentStoreCoordinator.executeRequest(NSBatchDeleteRequest(fetchRequest: fetchRequest), withContext: managedObjectContext)
        } catch {
            let nserror = error as NSError
            print("Delete error \(nserror), \(nserror.userInfo)")
        }
    }

}
