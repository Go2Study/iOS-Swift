//
//  FontysOAuthViewController.swift
//  Go2Study
//
//  Created by Ashish Kumar on 29/11/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

import UIKit
import SwiftyJSON

class FontysOAuthViewController: UIViewController, FontysClientDelegate, G2SClientDelegate {
    
    var fontysClient = FontysClient()
    var g2sClient = G2SClient()
    
    
    // MARK: - Public
    
    func oauthSuccessful() {
        fontysClient.delegate = self
        fontysClient.getUser("me")
    }
    
    
    // MARK: - Actions
    
    @IBAction func buttonLoginTouched() {
        UIApplication.sharedApplication().openURL(FontysClient().oauthURL)
    }
    
    
    // MARK: - FontysClientDelegate
    
    func fontysClient(client: FontysClient, didFailWithError error: NSError) {
        print("Request error \(error), \(error.userInfo)")
    }
    
    func fontysClient(client: FontysClient, didGetUserData data: NSData?, forPCN pcn: String) {
        let json = JSON(data: data!)
        var user = [String:String]()
        
        user["firstName"] = json["givenName"].stringValue
        user["lastName"]  = json["surName"].stringValue
        user["pcn"]       = json["id"].stringValue
        user["email"]     = json["mail"].stringValue
        
        g2sClient.delegate = self
        
        do {
            try g2sClient.postUser(JSON(user).rawData())
        } catch {
            let nserror = error as NSError
            print("POST error \(nserror), \(nserror.userInfo)")
        }
    }
    
    // MARK: - G2SClientDelegate
    
    func g2sClient(client: G2SClient, didFailWithError error: NSError) {
        print("Request error \(error), \(error.userInfo)")
    }

}
