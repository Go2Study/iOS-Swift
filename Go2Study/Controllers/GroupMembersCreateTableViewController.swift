//
//  GroupMembersCreateTableViewController.swift
//  Go2Study
//
//  Created by Ashish Kumar on 02/12/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class GroupMembersCreateViewController: UITableViewController, G2SClientDelegate {

    @IBOutlet weak var buttonSave: UIBarButtonItem!
    
    var g2sClient = G2SClient()
    var groupName: String?
    var groupMembers = [User]()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }()
    
    lazy var studentsFetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "type == %@", "student")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "displayName", ascending: true)]
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Choose Members: \(groupName!)"
        
        g2sClient.delegate = self
        
        do {
            try studentsFetchedResultsController.performFetch()
        } catch {
            let nserror = error as NSError
            print("Load error \(nserror), \(nserror.userInfo)")
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if studentsFetchedResultsController.sections?.count > 0 {
            return studentsFetchedResultsController.sections![section].numberOfObjects
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("groupStudentSelect") as! PeopleStudentTableViewCell
        let user = studentsFetchedResultsController.objectAtIndexPath(indexPath) as! User
        cell.configure(user)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        let user = studentsFetchedResultsController.objectAtIndexPath(indexPath) as! User
        
        if cell.accessoryType == .None {
            cell.accessoryType = .Checkmark
            groupMembers.append(user)
        } else {
            cell.accessoryType = .None
            if let index = groupMembers.indexOf(user) {
                groupMembers.removeAtIndex(index)
            }
        }
        
        if groupMembers.count > 0 {
            buttonSave.enabled = true
        } else {
            buttonSave.enabled = false
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    // MARK: - Actions
    
    @IBAction func buttonSaveTouched(sender: UIBarButtonItem) {
        buttonSave.enabled = false
        
        let group = NSEntityDescription.insertNewObjectForEntityForName("Group", inManagedObjectContext: managedObjectContext) as! Group
        
        group.name = groupName
        group.users = NSSet(array: groupMembers)
        
        do {
            try managedObjectContext.save()
            
            var jsonGroup = [String:String]()
            jsonGroup["name"] = group.name
            jsonGroup["pcnlist"] = ""
            
            for user in groupMembers {
                jsonGroup["pcnlist"] = jsonGroup["pcnlist"]! + user.pcn! + ","
            }
            
            do {
                try g2sClient.postGroup(JSON(jsonGroup).rawData())
            } catch {
                buttonSave.enabled = true
                let nserror = error as NSError
                print("POST error \(nserror), \(nserror.userInfo)")
            }
            
        } catch {
            let nserror = error as NSError
            print("Save error \(nserror), \(nserror.userInfo)")
        }
        
    }
    
    
    // MARK: - G2SClientDelegate
    
    func g2sClient(client: G2SClient, didFailWithError error: NSError) {
        print("Request error \(error), \(error.userInfo)")
        buttonSave.enabled = true
    }
    
    func g2sClient(client: G2SClient, didPostGroupWithResponse response: NSData?) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
}
