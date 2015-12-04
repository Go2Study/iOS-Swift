//
//  PeopleStaffTableViewCell.swift
//  Go2Study
//
//  Created by Ashish Kumar on 29/11/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

import UIKit

class PeopleStaffTableViewCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var office: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photo.layer.cornerRadius = 4
        photo.clipsToBounds = true
        photo.backgroundColor = UIColor.whiteColor()
    }
    
}

extension PeopleStaffTableViewCell {
    
    func configure(user: User) {
        name.text = user.displayName
        office.text = user.office
        
        if let photo = user.photo {
            self.photo.image = UIImage(data: photo)
        } else {
            self.photo.image = nil
        }
    }
    
}
