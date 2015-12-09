//
//  UIImage.swift
//  Go2Study
//
//  Created by Ashish Kumar on 09/12/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

import UIKit

extension UIImage {
    
    enum AssetIdentifier: String {
        case TabBarCalendar         = "TabBarCalendar"
        case TabBarCalendarSelected = "TabBarCalendarSelected"
        case TabBarMessages         = "TabBarMessages"
        case TabBarMessagesSelected = "TabBarMessagesSelected"
        case TabBarPeople           = "TabBarPeople"
        case TabBarPeopleSelected   = "TabBarPeopleSelected"
        case TabBarRecent           = "TabBarRecent"
        case TabBarRecentSelected   = "TabBarRecentSelected"
        case TabBarSettings         = "TabBarSettings"
        case TabBarSettingsSelected = "TabBarSettingsSelected"
    }
    
    convenience init!(assetIdentifier: AssetIdentifier) {
        self.init(named: assetIdentifier.rawValue)
    }
    
}
