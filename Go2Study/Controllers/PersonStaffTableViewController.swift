//
//  PersonStaffTableViewController.swift
//  Go2Study
//
//  Created by Ashish Kumar on 30/11/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

import UIKit

class PersonStaffTableViewController: UITableViewController {

    var user: User?
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDepartment: UILabel!
    
    @IBOutlet weak var labelOffice: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(user!.firstName!) \(user!.lastName!)"
        
        labelName.text       = user!.displayName
        labelTitle.text      = user!.title
        labelDepartment.text = user!.department
        labelOffice.text     = user!.office
        labelEmail.text      = user!.mail
        labelPhone.text      = user!.phone
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "StaffShowCalendar" {
            let calendarViewController = segue.destinationViewController as! CalendarTableViewController
            calendarViewController.personalTitle = user?.personalTitle
        }
    }
    
}
