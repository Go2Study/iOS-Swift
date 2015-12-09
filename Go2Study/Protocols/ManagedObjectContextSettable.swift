//
//  ManagedObjectContextSettable.swift
//  Go2Study
//
//  Created by Ashish Kumar on 09/12/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

import CoreData

protocol ManagedObjectContextSettable: class {
    
    var managedObjectContext: NSManagedObjectContext! { get set }
    
}
