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

class PeopleTableViewController: UITableViewController, FontysClientDelegate, G2SClientDelegate {

    enum displayOptions {
        case Students
        case Staff
        case Groups
    }
    
    
    // MARK: - Properties
    
    @IBOutlet weak var buttonCreateGroup: UIBarButtonItem!
    
    var fontysClient = FontysClient()
    var g2sClient = G2SClient()
    var currentDisplay: displayOptions = .Staff
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
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
        g2sClient.delegate = self
        fontysClient.delegate = self
        reloadData()
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
        
        reloadData()
    }
    
    @IBAction func buttonRefreshTouched(sender: UIBarButtonItem) {
        switch currentDisplay {
        case .Students:
            g2sClient.getUsers()
        case .Staff:
            fontysClient.getUsers()
        case .Groups:
            break
        }
        
        reloadData()
    }
    
    @IBAction func buttonAddGroupTouched(sender: UIBarButtonItem) {
        
    }
    
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
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
            break
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("peopleStaffCell") as! PeopleStaffTableViewCell
        
        switch currentDisplay {
        case .Students :
            let cell = tableView.dequeueReusableCellWithIdentifier("peopleStudentCell") as! PeopleStudentTableViewCell
            let user = studentsFetchedResultsController.objectAtIndexPath(indexPath) as! User
            cell.name.text = user.displayName
            cell.photo.image = nil
            return cell
            
        case .Staff:
            let user = staffFetchedResultsController.objectAtIndexPath(indexPath) as! User
            cell.name.text = user.displayName
            cell.office.text = user.office
            
            if let photo = user.photo {
                cell.photo.image = UIImage(data: photo)
            } else {
                cell.photo.image = nil
            }
            
            return cell
            
        case .Groups:
            break
        }
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "peopleShowStaff" && currentDisplay == .Staff {
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
            let personStaffViewController = segue.destinationViewController as! PersonStaffTableViewController
            personStaffViewController.user = staffFetchedResultsController.objectAtIndexPath(indexPath) as? User
        } else if segue.identifier == "peopleShowStudent" && currentDisplay == .Students {
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
            let personStudentViewController = segue.destinationViewController as! PersonStudentTableViewController
            personStudentViewController.user = studentsFetchedResultsController.objectAtIndexPath(indexPath) as? User
        }
    }
    
    
    // MARK: - Private
    
    private func reloadData() {
        do {
            switch currentDisplay {
            case .Students:
                try studentsFetchedResultsController.performFetch()
                
            case .Staff:
                try staffFetchedResultsController.performFetch()
                
            case .Groups:
                break
            }
        } catch {
            let nserror = error as NSError
            print("Reload error \(nserror), \(nserror.userInfo)")
        }
        
        tableView.reloadData()
    }
    
    private func deleteUserData() {
        let fetchRequest = NSFetchRequest(entityName: "User")
        
        switch currentDisplay {
        case .Students:
            fetchRequest.predicate = NSPredicate(format: "type == %@", "student")
        case .Staff:
            fetchRequest.predicate = NSPredicate(format: "type == %@", "staff")
        case .Groups:
            break
        }
        
        do {
            try persistentStoreCoordinator.executeRequest(NSBatchDeleteRequest(fetchRequest: fetchRequest), withContext: managedObjectContext)
        } catch {
            let nserror = error as NSError
            print("Delete error \(nserror), \(nserror.userInfo)")
        }
        
    }
    
    
    // MARK: - FontysClientDelegate
    
    func fontysClient(client: FontysClient, didFailWithError error: NSError) {
        print("Request error \(error), \(error.userInfo)")
    }
    
    func fontysClient(client: FontysClient, didGetUsersData data: NSData?) {
        if (data != nil) {
            deleteUserData()
        }
        
        for (_, userDictionary) in JSON(data: data!) {
            let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: managedObjectContext) as! User
            
            user.firstName   = userDictionary["givenName"].stringValue
            user.lastName    = userDictionary["surName"].stringValue
            user.displayName = userDictionary["displayName"].stringValue
            user.initials    = userDictionary["initials"].stringValue
            user.mail        = userDictionary["mail"].stringValue
            user.office      = userDictionary["office"].stringValue
            user.phone       = userDictionary["telephoneNumber"].stringValue
            user.pcn         = userDictionary["id"].stringValue
            user.title       = userDictionary["title"].stringValue
            user.department  = userDictionary["department"].stringValue
            user.type        = "staff"
            
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                print("Save error \(nserror), \(nserror.userInfo)")
            }
        }
        
        reloadData()
    }
    
    func fontysClient(client: FontysClient, didGetUserImage data: NSData?, forPCN pcn: String) {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedObjectContext)
        fetchRequest.predicate = NSPredicate(format: "pcn == %@", pcn)
        do {
            let fetchedObjects = try managedObjectContext.executeFetchRequest(fetchRequest)
            if fetchedObjects.count > 0 {
                let user = fetchedObjects.first as! User
                user.photo = data
            }
        } catch {
            let nserror = error as NSError
            print("User fetch error \(nserror), \(nserror.userInfo)")
        }
    }
    
    
    // MARK: - G2SClientDelegate
    
    func g2sClient(client: G2SClient, didFailWithError error: NSError) {
        print("Request error \(error), \(error.userInfo)")
    }
    
    func g2sClient(client: G2SClient, didGetUsersData data: NSData?) {
        if (data != nil) {
            deleteUserData()
        }
        
        for (_, userDictionary) in JSON(data: data!) {
            let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: managedObjectContext) as! User
            
            user.firstName   = userDictionary["firstName"].stringValue
            user.lastName    = userDictionary["lastName"].stringValue
            user.displayName = userDictionary["displayName"].stringValue
            user.mail        = userDictionary["email"].stringValue
            user.pcn         = userDictionary["pcn"].stringValue
            user.type        = "student"
            
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                print("Save error \(nserror), \(nserror.userInfo)")
            }
        }
        
        reloadData()
    }
}
