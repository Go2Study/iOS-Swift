//
//  PeopleUserTableViewCell.swift
//  Go2Study
//
//  Created by Ashish Kumar on 09/12/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

import UIKit

class PeopleUserTableViewCell: UITableViewCell {
    
    var name: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var photo: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.whiteColor()
        imageView.clipsToBounds = true
        imageView.frame = CGRectMake(8, 8, 46, 46)
        imageView.layer.cornerRadius = 4
        imageView.layer.borderColor = UIColor.groupTableViewBackgroundColor().CGColor
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        separatorInset = UIEdgeInsetsMake(0, 70, 0, 0)
        
        contentView.addSubview(name)
        contentView.addSubview(photo)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(user: User) {
        name.text = user.displayName
        
        if let photo = user.photo {
            self.photo.image = UIImage(data: photo)
        } else {
            photo.image = nil
        }
    }

}