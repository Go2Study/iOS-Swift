//
//  FontysClient.swift
//  Go2Study
//
//  Created by Ashish Kumar on 29/11/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

import Foundation

class FontysClient {
    
    // MARK: - Constants
    
    let ClientID    = "i271628-go2study-implicit"
    let Scopes      = "fhict+fhict_personal+fhict_location"
    let CallbackURL = "go2study://oauth/authorize"
    let apiBaseURL  = NSURL(string: "https://tas.fhict.nl:443/api/v1/")
    
    
    // MARK: - Properties
    
    var oauthURL: NSURL {
        get {
            return NSURL(string: "https://tas.fhict.nl/identity/connect/authorize?client_id=\(ClientID)&scope=\(Scopes)&response_type=token&redirect_uri=\(CallbackURL)")!
        }
    }
    
    var accessToken: String {
        get {
            return NSUserDefaults.standardUserDefaults().valueForKey("fhictAccessToken") as! String
        }
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "fhictAccessToken")
        }
    }
    
    // MARK: - OAuth
    
    func saveAccessToken(url: NSURL) {
        let URLComponents = url.fragment?.componentsSeparatedByString("&")
        var URLParameters = [String: String]()
        
        for keyValuePair in URLComponents! {
            let pairComponents = keyValuePair.componentsSeparatedByString("=")
            let key = pairComponents.first?.stringByRemovingPercentEncoding
            let value = pairComponents.last?.stringByRemovingPercentEncoding
            
            URLParameters[key!] = value
        }
        
        accessToken = URLParameters["access_token"]!
    }

}
