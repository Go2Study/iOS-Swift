//
//  PeopleViewController.swift
//  Go2Study
//
//  Created by Ashish Kumar on 09/12/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class PeopleViewController: UIViewController {
    
    // MARK: - Properties
    
    enum displayOptions {
        case Students
        case Staff
        case Groups
    }

    var currentDisplay = displayOptions.Staff
    var fontysClient = FontysClient()
    var g2sClient = G2SClient()
    
    
    // MARK: Interface Elements
    
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Students", "Staff", "Groups"])
        segmentedControl.selectedSegmentIndex = 1
        return segmentedControl
    }()
    
    lazy var buttonCreateGroup = UIBarButtonItem(barButtonSystemItem: .Add, target: nil, action: Selector("buttonCreateGroupTouched"))
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlValueChanged", forControlEvents: .ValueChanged)
        return refreshControl
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero)
        tableView.addSubview(self.refreshControl)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(PeopleStaffTableViewCell.self, forCellReuseIdentifier: "PeopleStaffCell")
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    // MARK: Core Data
    
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
        
        // Configure Target-Actions
        segmentedControl.addTarget(self, action: Selector("segmentedControlChanged:"), forControlEvents: .ValueChanged)
        buttonCreateGroup.target = self
        
        // Add Views
        navigationItem.titleView = segmentedControl
        view.addSubview(tableView)
        
        autolayout()
        
        g2sClient.delegate = self
        fontysClient.delegate = self
        
        reloadTableView()
    }
    
    
    // MARK: - Actions
    
    func segmentedControlChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 { // students
            currentDisplay = .Students
            navigationItem.rightBarButtonItem = nil
        } else if sender.selectedSegmentIndex == 1 { // staff
            currentDisplay = .Staff
            navigationItem.rightBarButtonItem = nil
        } else if sender.selectedSegmentIndex == 2 { // groups
            currentDisplay = .Groups
            navigationItem.rightBarButtonItem = buttonCreateGroup
        }
    }
    
    func buttonCreateGroupTouched() {
        print("buttonCreateGroupTouched")
    }
    
    func refreshControlValueChanged() {
        refreshData()
    }
    
}

// MARK: - UITableView

extension PeopleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch currentDisplay {
        case .Students :
            break
            
        case .Staff:
            let cell = tableView.dequeueReusableCellWithIdentifier("PeopleStaffCell") as! PeopleStaffTableViewCell
            let user = staffFetchedResultsController.objectAtIndexPath(indexPath) as! User
            
            cell.configure(user)
            cell.accessoryType = .DisclosureIndicator
            return cell
            
        case .Groups:
            break
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64.0
    }
}


// MARK: - FontysClientDelegate

extension PeopleViewController: FontysClientDelegate {
    
    func fontysClient(client: FontysClient, didFailWithError error: NSError) {
        refreshControl.endRefreshing()
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
        refreshControl.endRefreshing()
    }
    
    func fontysClient(client: FontysClient, didGetUserImage data: NSData?, forPCN pcn: String) {
        User.savePhoto(data!, forPCN: pcn, inManagedObjectContext: managedObjectContext)
        saveContext()
    }
}


// MARK: - G2SClientDelegate

extension PeopleViewController: G2SClientDelegate {
    
    func g2sClient(client: G2SClient, didFailWithError error: NSError) {
        refreshControl.endRefreshing()
        print("Request error \(error), \(error.userInfo)")
    }
    
    func g2sClient(client: G2SClient, didGetUsersData data: NSData) {
        deleteData()
        
        for (_, userDictionary) in JSON(data: data) {
            User.insertStudent(userDictionary, inManagedObjectContext: managedObjectContext)
        }
        
        saveContext()
        reloadTableView()
        refreshControl.endRefreshing()
    }
    
    func g2sClient(client: G2SClient, didGetGroupsData data: NSData) {
        deleteData()
        
        for (_, groupDictionary) in JSON(data: data) {
            Group.insert(groupDictionary, inManagedObjectContext: managedObjectContext)
        }
        
        saveContext()
        reloadTableView()
        refreshControl.endRefreshing()
    }
}


// MARK: - Private

private extension PeopleViewController {
    
    func autolayout() {
        let views = [
            "tableView": tableView
        ]
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: .AlignAllLeft, metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]|", options: .AlignAllLeft, metrics: nil, views: views))
    }
    
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