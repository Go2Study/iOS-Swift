//
//  GroupTableViewController.swift
//  Go2Study
//
//  Created by Ashish Kumar on 02/12/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

import UIKit
import CoreData

class GroupTableViewController: UITableViewController, G2SClientDelegate {

    var group: Group?
    var g2sClient = G2SClient()
    
    @IBOutlet weak var deleteGroupCell: UITableViewCell!
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }()
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = group?.name
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        g2sClient.delegate = self
    }
    
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.cellForRowAtIndexPath(indexPath)?.isEqual(deleteGroupCell) == true {
            let alertController = UIAlertController(title: "Delete Group '\((group?.name)!)'?",
                                                    message: "Are you sure you want to delete '\((group?.name)!)'?",
                                                    preferredStyle: .Alert)
            
            let buttonCancel = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                alertController.dismissViewControllerAnimated(true, completion: nil)
            })
            
            let buttonDelete = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: { (action) -> Void in
                let groupId = self.group?.id?.intValue
                self.g2sClient.deleteGroup(groupId!)
                alertController.dismissViewControllerAnimated(true, completion: nil)
                self.navigationController?.popToRootViewControllerAnimated(true)
            })
            
            alertController.addAction(buttonCancel)
            alertController.addAction(buttonDelete)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "groupShowMembers" {
            let groupMembersViewController = segue.destinationViewController as! GroupMembersListTableViewController
            groupMembersViewController.group = group
        }
    }
    
    
    // MARK: - Private
    
    private func deleteGroup() {
        managedObjectContext.deleteObject(group!)
        do {
            try managedObjectContext.save()
        } catch {
            let nserror = error as NSError
            print("Delete error \(nserror), \(nserror.userInfo)")
        }
    }
    
}
