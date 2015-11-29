//
//  FontysOAuthViewController.swift
//  Go2Study
//
//  Created by Ashish Kumar on 29/11/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

import UIKit

class FontysOAuthViewController: UIViewController {
    
    @IBAction func buttonLoginTouched() {
        UIApplication.sharedApplication().openURL(FontysClient().oauthURL)
    }

}
