//
//  PeopleStudentTableViewController.swift
//  Go2Study
//
//  Created by Ashish Kumar on 30/11/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

import UIKit

class PersonStudentTableViewController: UITableViewController {
    
    var user: User?

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPCN: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(user!.firstName!) \(user!.lastName!)"
        
        labelName.text       = user!.displayName
        labelPCN.text        = user!.pcn
        labelEmail.text      = user!.mail
    }
}
