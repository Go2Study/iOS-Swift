//
//  GroupMembersTableViewController.swift
//  Go2Study
//
//  Created by Ashish Kumar on 02/12/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

import UIKit
import CoreData

class GroupMembersTableViewController: UITableViewController {

    @IBOutlet weak var buttonSave: UIBarButtonItem!
    
    var groupName: String?
    var groupMembers = [String]()
    
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
        let cell = tableView.dequeueReusableCellWithIdentifier("groupStudentSelect")!
        let user = studentsFetchedResultsController.objectAtIndexPath(indexPath) as! User
        cell.textLabel?.text = user.displayName
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        let user = studentsFetchedResultsController.objectAtIndexPath(indexPath) as! User
        
        if cell.accessoryType == .None {
            cell.accessoryType = .Checkmark
            groupMembers.append(user.pcn!)
        } else {
            cell.accessoryType = .None
            if let index = groupMembers.indexOf(user.pcn!) {
                groupMembers.removeAtIndex(index)
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    // MARK: - Actions
    
    @IBAction func buttonSaveTouched(sender: UIBarButtonItem) {
    }
    
}
