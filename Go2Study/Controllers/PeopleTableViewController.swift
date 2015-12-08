//
//  PeopleTableViewController.swift
//  Go2Study
//
//  Created by Ashish Kumar on 29/11/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class PeopleTableViewController: UITableViewController {

    private enum displayOptions {
        case Students
        case Staff
        case Groups
    }
    
    
    // MARK: - Properties
    
    @IBOutlet weak var buttonCreateGroup: UIBarButtonItem!
    
    var fontysClient = FontysClient()
    var g2sClient = G2SClient()
    private var currentDisplay: displayOptions = .Staff
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        managedObjectContext.performBlockAndWait({
            managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        })
        return managedObjectContext
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).persistentStoreCoordinator
    }()
    
    lazy var studentsFetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "type == %@", "student")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "displayName", ascending: true)]
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    lazy var staffFetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "type == %@", "staff")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "displayName", ascending: true)]
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    lazy var groupsFetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Group")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: "refreshData", forControlEvents: .ValueChanged)
        
        g2sClient.delegate = self
        fontysClient.delegate = self
        
        reloadTableView()
    }
    
    
    // MARK: - Actions
    
    @IBAction func segmentedControlChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 { // students
            currentDisplay = .Students
            buttonCreateGroup.enabled = false
        } else if sender.selectedSegmentIndex == 1 { // staff
            currentDisplay = .Staff
            buttonCreateGroup.enabled = false
        } else if sender.selectedSegmentIndex == 2 { // groups
            currentDisplay = .Groups
            buttonCreateGroup.enabled = true
        }
        
        reloadTableView()
    }
    
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentDisplay {
        case .Students:
            if studentsFetchedResultsController.sections?.count > 0 {
                return studentsFetchedResultsController.sections![section].numberOfObjects
            }
        case .Staff:
            if staffFetchedResultsController.sections?.count > 0 {
                return staffFetchedResultsController.sections![section].numberOfObjects
            }
        case .Groups:
            if groupsFetchedResultsController.sections?.count > 0 {
                return groupsFetchedResultsController.sections![section].numberOfObjects
            }
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch currentDisplay {
        case .Students :
            let cell = tableView.dequeueReusableCellWithIdentifier("peopleStudentCell", forIndexPath: indexPath) as! PeopleStudentTableViewCell
            let user = studentsFetchedResultsController.objectAtIndexPath(indexPath) as! User
            
            cell.configure(user)
            return cell
            
        case .Staff:
            let cell = tableView.dequeueReusableCellWithIdentifier("peopleStaffCell", forIndexPath: indexPath) as! PeopleStaffTableViewCell
            let user = staffFetchedResultsController.objectAtIndexPath(indexPath) as! User
            cell.configure(user)
            return cell
            
        case .Groups:
            let cell = tableView.dequeueReusableCellWithIdentifier("peopleGroupCell", forIndexPath: indexPath) as! PeopleGroupViewCell
            let group = groupsFetchedResultsController.objectAtIndexPath(indexPath) as! Group
            cell.configure(group)
            return cell
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PeopleShowStaff" {
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
            let personStaffViewController = segue.destinationViewController as! PersonStaffTableViewController
            personStaffViewController.user = staffFetchedResultsController.objectAtIndexPath(indexPath) as? User
        } else if segue.identifier == "PeopleShowStudent" {
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
            let personStudentViewController = segue.destinationViewController as! PersonStudentTableViewController
            personStudentViewController.user = studentsFetchedResultsController.objectAtIndexPath(indexPath) as? User
        } else if segue.identifier == "PeopleShowGroup" {
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
            let groupViewController = segue.destinationViewController as! GroupTableViewController
            groupViewController.group = groupsFetchedResultsController.objectAtIndexPath(indexPath) as? Group
        }
    }
}


// MARK: - FontysClientDelegate

extension PeopleTableViewController: FontysClientDelegate {
    
    func fontysClient(client: FontysClient, didFailWithError error: NSError) {
        refreshControl!.endRefreshing()
        print("Request error \(error), \(error.userInfo)")
    }
    
    func fontysClient(client: FontysClient, didFailWithOAuthError errorCode: Int) {
        (UIApplication.sharedApplication().delegate as! AppDelegate).refreshFontysAccessToken()
    }
    
    func fontysClient(client: FontysClient, didGetUsersData data: NSData?) {
        deleteData()
        
        for (_, userDictionary) in JSON(data: data!) {
            User.insertStaff(userDictionary, inManagedObjectContext: managedObjectContext)
        }
        
        saveContext()
        reloadTableView()
        refreshControl!.endRefreshing()
    }
    
    func fontysClient(client: FontysClient, didGetUserImage data: NSData?, forPCN pcn: String) {
        User.savePhoto(data!, forPCN: pcn, inManagedObjectContext: managedObjectContext)
        saveContext()
    }
}


// MARK: - G2SClientDelegate

extension PeopleTableViewController: G2SClientDelegate {
    
    func g2sClient(client: G2SClient, didFailWithError error: NSError) {
        refreshControl!.endRefreshing()
        print("Request error \(error), \(error.userInfo)")
    }
    
    func g2sClient(client: G2SClient, didGetUsersData data: NSData) {
        deleteData()
        
        for (_, userDictionary) in JSON(data: data) {
            User.insertStudent(userDictionary, inManagedObjectContext: managedObjectContext)
        }
        
        saveContext()
        reloadTableView()
        refreshControl!.endRefreshing()
    }
    
    func g2sClient(client: G2SClient, didGetGroupsData data: NSData) {
        deleteData()
        
        for (_, groupDictionary) in JSON(data: data) {
            Group.insert(groupDictionary, inManagedObjectContext: managedObjectContext)
        }
        
        saveContext()
        reloadTableView()
        refreshControl!.endRefreshing()
    }
}


// MARK: - Private

private extension PeopleTableViewController {
    @objc func refreshData() {
        switch currentDisplay {
        case .Students:
            g2sClient.getUsers()
        case .Staff:
            fontysClient.getUsers()
        case .Groups:
            g2sClient.getGroups()
        }
        
        reloadTableView()
    }
    
    func reloadTableView() {
        dispatch_async(dispatch_get_main_queue()) {
            do {
                switch self.currentDisplay {
                case .Students:
                    try self.studentsFetchedResultsController.performFetch()
                    
                case .Staff:
                    try self.staffFetchedResultsController.performFetch()
                    
                case .Groups:
                    try self.groupsFetchedResultsController.performFetch()
                }
            } catch {
                let nserror = error as NSError
                print("Reload error \(nserror), \(nserror.userInfo)")
            }
            
            self.tableView.reloadData()
        }
    }
    
    func deleteData() {
        switch currentDisplay {
        case .Students:
            User.deleteAll("student", inManagedObjectContext: managedObjectContext, persistentStoreCoordinator: persistentStoreCoordinator)
        case .Staff:
            User.deleteAll("staff", inManagedObjectContext: managedObjectContext, persistentStoreCoordinator: persistentStoreCoordinator)
        case .Groups:
            Group.deleteAll(managedObjectContext, persistentStoreCoordinator: persistentStoreCoordinator)
        }
        reloadTableView()
    }
    
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
