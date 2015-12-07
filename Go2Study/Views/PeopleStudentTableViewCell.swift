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
        
        photo.backgroundColor = UIColor.whiteColor()
        photo.clipsToBounds   = true
        photo.layer.cornerRadius = 4
        photo.layer.borderColor  = UIColor.groupTableViewBackgroundColor().CGColor
        photo.layer.borderWidth  = 1
    }
}

extension PeopleStudentTableViewCell {
    
    func configure(user: User) {
        name.text = user.displayName
        
        if let photo = user.photo {
            self.photo.image = UIImage(data: photo)
        } else {
            photo.image = nil
        }
        
    }
    
}