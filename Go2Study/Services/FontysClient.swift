//
//  FontysClient.swift
//  Go2Study
//
//  Created by Ashish Kumar on 29/11/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

import Foundation

@objc protocol FontysClientDelegate {
    // Errors
    optional func fontysClient(client: FontysClient, didFailWithError error: NSError)
    optional func fontysClient(client: FontysClient, didFailWithOAuthError errorCode: Int)
    
    // Users
    optional func fontysClient(client: FontysClient, didGetUsersData data: NSData?)
    optional func fontysClient(client: FontysClient, didGetUserData data: NSData?, forPCN pcn: String)
    
    // Images
    optional func fontysClient(client: FontysClient, didGetUserImage data: NSData?, forPCN pcn: String)
    
    // Schedule
    optional func fontysClient(client: FontysClient, didGetSchedule schedule: NSData?, forKind kind: String, query: String)
}

@objc class FontysClient : NSObject {
    
    let ClientID    = "i271628-go2study-implicit"
    let Scopes      = "fhict+fhict_personal+fhict_location"
    let CallbackURL = "go2study://oauth/authorize"
    let apiBaseURL  = NSURL(string: "https://tas.fhict.nl:443/api/v1/")
    
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
    
    func resetAccessToken() {
        accessToken = nil
        NSUserDefaults.standardUserDefaults().removeObjectForKey("fhictAccessToken")
    }
    
    
    // MARK: - Users
    
    func getUsers() {
        let config = configure("people?includeThumbs=true", HTTPMethod: "GET")
        
        config.session.dataTaskWithRequest(config.request) { (data, response, error) -> Void in
            if error != nil {
                self.delegate!.fontysClient?(self, didFailWithError: error!)
            } else if (response as! NSHTTPURLResponse).statusCode == 401 {
                self.delegate!.fontysClient?(self, didFailWithOAuthError: 401)
            } else {
                self.delegate!.fontysClient?(self, didGetUsersData: data!)
            }
        }.resume()
    }
    
    func getUser(pcn: String) {
        let config = configure("people/\(pcn)", HTTPMethod: "GET")
        
        config.session.dataTaskWithRequest(config.request) { (data, response, error) -> Void in
            if error != nil {
                self.delegate!.fontysClient?(self, didFailWithError: error!)
            } else if (response as! NSHTTPURLResponse).statusCode == 401 {
                self.delegate!.fontysClient?(self, didFailWithOAuthError: 401)
            } else {
                self.delegate!.fontysClient?(self, didGetUserData: data, forPCN: pcn)
            }
        }.resume()
    }
    
    
    // MARK: - Images
    
    func getImage(pcn: String) {
        let config = configure("pictures/\(pcn)/medium", HTTPMethod: "GET")
        
        config.session.downloadTaskWithRequest(config.request) { (url, response, error) -> Void in
            if error != nil {
                self.delegate!.fontysClient?(self, didFailWithError: error!)
            } else if (response as! NSHTTPURLResponse).statusCode == 401 {
                self.delegate!.fontysClient?(self, didFailWithOAuthError: 401)
            } else {
                let data = NSData(contentsOfURL: url!)
                self.delegate!.fontysClient?(self, didGetUserImage: data, forPCN: pcn)
            }
        }.resume()
    }
    
    
    // MARK: - Schedule
    
    func getSchedule(kind: String, query: String) {
        let config = configure("schedule/\(kind)/\(query)?days=30", HTTPMethod: "GET")
        
        config.session.dataTaskWithRequest(config.request) { (data, response, error) -> Void in
            if error != nil {
                self.delegate!.fontysClient?(self, didFailWithError: error!)
            } else if (response as! NSHTTPURLResponse).statusCode == 401 {
                self.delegate!.fontysClient?(self, didFailWithOAuthError: 401)
            } else {
                
                self.delegate!.fontysClient?(self, didGetSchedule: data, forKind: kind, query: query)
            }
        }.resume()
    }

}


// MARK: - Private

private extension FontysClient {
    
    func configure(endpoint: String, HTTPMethod: String) -> (session: NSURLSession, request: NSMutableURLRequest) {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = ["Authorization": "Bearer \(accessToken!)"]
        let session = NSURLSession(configuration: configuration, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        
        let url = NSURL(string: endpoint, relativeToURL: apiBaseURL)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = HTTPMethod
        
        return (session, request)
    }
    
}