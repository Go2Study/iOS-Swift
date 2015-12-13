//
//  PeopleStudentTableViewCell.swift
//  Go2Study
//
//  Created by Ashish Kumar on 29/11/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

import UIKit

class PeopleStudentTableViewCell: PeopleUserTableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        autolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func autolayout() {
        let views = [
            "name": name,
            "photo": photo
        ]
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[photo(46)]-8-[name(>=10)]-|", options: .AlignAllCenterY, metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-9-[photo(46)]", options: .AlignAllBaseline, metrics: nil, views: views))
    }

}