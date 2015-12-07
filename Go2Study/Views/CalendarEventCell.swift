//
//  CalendarEventCell.swift
//  Go2Study
//
//  Created by Ashish Kumar on 07/12/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

import UIKit

class CalendarEventCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var time: UILabel!
}

extension CalendarEventCell {
    
    func configure(name: String, location: String, time: String) {
        self.name.text     = name
        self.location.text = location
        self.time.text     = time
    }
    
}