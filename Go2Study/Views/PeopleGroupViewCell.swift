//
//  PeopleGroupStudentViewCell.swift
//  Go2Study
//
//  Created by Ashish Kumar on 29/11/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

import UIKit

class PeopleGroupViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
}

extension PeopleGroupViewCell {
    
    func configure(group: Group) {
        name.text = group.name
    }
    
}