//
//  PeopleStaffTableViewCell.swift
//  Go2Study
//
//  Created by Ashish Kumar on 29/11/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

import UIKit

class PeopleStaffTableViewCell: PeopleUserTableViewCell {

    var office: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        label.sizeToFit()
        label.textColor = UIColor.grayColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(office)
        autolayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func configure(user: User) {
        super.configure(user)
        office.text = user.office
    }
    
    private func autolayout() {
        let views = [
            "name": name,
            "office": office,
            "photo": photo
        ]
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[photo(46)]-8-[name(>=10)]-|", options: .AlignAllTop, metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-9-[photo(46)]", options: .AlignAllBaseline, metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[name(21)]-6-[office]", options: .AlignAllLeft, metrics: nil, views: views))
    }
}
