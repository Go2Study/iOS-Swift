//
//  GroupMembersListTableViewController.swift
//  Go2Study
//
//  Created by Ashish Kumar on 02/12/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

import UIKit

class GroupMembersListTableViewController: UITableViewController {

    var group: Group?
    lazy var users: [User] = {
        let sortDescriptor = NSSortDescriptor(key: "displayName", ascending: true)
        return self.group?.users?.sortedArrayUsingDescriptors([sortDescriptor]) as! [User]
    }()
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = group?.name
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("groupStudentCell") as! PeopleStudentTableViewCell
        let user = users[indexPath.row]
        cell.name.text = user.displayName
        cell.photo.image = nil
        return cell
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "groupShowStudent" {
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
            let personStudentViewController = segue.destinationViewController as! PersonStudentTableViewController
            personStudentViewController.user = users[indexPath.row]
        }
    }
}
