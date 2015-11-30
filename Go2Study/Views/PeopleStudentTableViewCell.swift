//
//  PeopleStudentTableViewCell.swift
//  Go2Study
//
//  Created by Ashish Kumar on 29/11/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

import UIKit

class PeopleStudentTableViewCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photo.layer.cornerRadius = 4
        photo.clipsToBounds = true
        photo.backgroundColor = UIColor.whiteColor()
    }
}
