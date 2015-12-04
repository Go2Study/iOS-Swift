//
//  FontysClient.swift
//  Go2Study
//
//  Created by Ashish Kumar on 29/11/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

import Foundation

@objc protocol FontysClientDelegate {
    optional func fontysClient(client: FontysClient, didFailWithError error: NSError)
    
    // Users
    optional func fontysClient(client: FontysClient, didGetUsersData data: NSData?)
    optional func fontysClient(client: FontysClient, didGetUserData data: NSData?, forPCN pcn: String)
    
    // Images
    optional func fontysClient(client: FontysClient, didGetUserImage data: NSData?, forPCN pcn: String)
}

@objc class FontysClient : NSObject {
    
    // MARK: - Constants
    
    private let ClientID    = "i271628-go2study-implicit"
    private let Scopes      = "fhict+fhict_personal+fhict_location"
    private let CallbackURL = "go2study://oauth/authorize"
    private let apiBaseURL  = NSURL(string: "https://tas.fhict.nl:443/api/v1/")
    
    
    // MARK: - Properties
    
    var delegate: FontysClientDelegate?
    
    var oauthURL: NSURL {
        get {
            return NSURL(string: "https://tas.fhict.nl/identity/connect/authorize?client_id=\(ClientID)&scope=\(Scopes)&response_type=token&redirect_uri=\(CallbackURL)")!
        }
    }
    
    var accessToken: String? {
        get {
            return NSUserDefaults.standardUserDefaults().valueForKey("fhictAccessToken") as? String
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
    
    
    // MARK: - Config
    
    private func getSessionAndRequest(endpoint: String, HTTPMethod: String) -> (session: NSURLSession, request: NSMutableURLRequest) {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = ["Authorization": "Bearer \(accessToken!)"]
        let session = NSURLSession(configuration: configuration, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        
        let url = NSURL(string: endpoint, relativeToURL: apiBaseURL)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = HTTPMethod
        
        return (session, request)
    }
    
    
    // MARK: - Users
    
    func getUsers() {
        let requestData = getSessionAndRequest("people?includeThumbs=false", HTTPMethod: "GET")
        
        let task = requestData.session.dataTaskWithRequest(requestData.request) { (data, response, error) -> Void in
            if error == nil {
                self.delegate!.fontysClient?(self, didGetUsersData: data!)
            } else {
                self.delegate!.fontysClient?(self, didFailWithError: error!)
            }
        }
        task.resume()
    }
    
    func getUser(pcn: String) {
        let requestData = getSessionAndRequest("people/\(pcn)", HTTPMethod: "GET")
        
        let task = requestData.session.dataTaskWithRequest(requestData.request) { (data, response, error) -> Void in
            if error == nil {
                self.delegate!.fontysClient?(self, didGetUserData: data, forPCN: pcn)
            } else {
                self.delegate!.fontysClient?(self, didFailWithError: error!)
            }
        }
        task.resume()
    }
    
    
    // MARK: - Images
    
    func getImage(pcn: String) {
        let requestData = getSessionAndRequest("pictures/\(pcn)/medium", HTTPMethod: "GET")
        let task = requestData.session.downloadTaskWithRequest(requestData.request) { (url, response, error) -> Void in
            if error == nil {
                let data = NSData(contentsOfURL: url!)
                self.delegate!.fontysClient?(self, didGetUserImage: data, forPCN: pcn)
            } else {
                self.delegate!.fontysClient?(self, didFailWithError: error!)
            }
        }
        task.resume()
    }

}
