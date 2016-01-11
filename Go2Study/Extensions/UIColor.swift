//
//  UIColor.swift
//  Go2Study
//
//  Created by Ashish Kumar on 11/01/16.
//  Copyright © 2016 Go2Study. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func primaryColor() -> UIColor { return fontysPurple() }
    class func tintColor() -> UIColor { return primaryColor() }
    
    // MARK: - Local Palette
    
    private class func fontysPurple() -> UIColor {
         return UIColor(red:0.48, green:0.31, blue:0.48, alpha:1.0)
    }
    
}