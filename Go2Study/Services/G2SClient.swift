//
//  G2SClient.swift
//  Go2Study
//
//  Created by Ashish Kumar on 30/11/15.
//  Copyright © 2015 Go2Study. All rights reserved.
//

import Foundation

@objc protocol G2SClientDelegate {
    optional func g2sClient(client: G2SClient, didFailWithError error: NSError)
    
    // Users
    optional func g2sClient(client: G2SClient, didGetUsersData data: NSData?)
    optional func g2sClient(client: G2SClient, didGetUserData data: NSData?, forPCN pcn: String)
    optional func g2sClient(client: G2SClient, didPostUserWithResponse response: NSData?)
    optional func g2sClient(client: G2SClient, didPutUserWithResponse response: NSData?, forPCN pcn: String)
    
    // Groups
    optional func g2sClient(client: G2SClient, didGetGroupsData data: NSData?)
    optional func g2sClient(client: G2SClient, didPostGroupWithResponse response: NSData?)
    optional func g2sClient(client: G2SClient, didDeleteGroup id: Int32)
}

@objc class G2SClient: NSObject {

    var delegate: G2SClientDelegate?
    let apiBaseURL = NSURL(string: "http://go2study.lol/api/")
    
    
    // MARK: - Users
    
    func getUsers() {
        let config = configure("users", HTTPMethod: "GET")
        
        config.session.dataTaskWithRequest(config.request) { (data, response, error) -> Void in
            if error == nil {
                self.delegate!.g2sClient?(self, didGetUsersData: data!)
            } else {
                self.delegate!.g2sClient?(self, didFailWithError: error!)
            }
        }.resume()
    }
    
    func getUser(pcn: String) {
        let config = configure("users/\(pcn)", HTTPMethod: "GET")
        
        config.session.dataTaskWithRequest(config.request) { (data, response, error) -> Void in
            if error == nil {
                self.delegate!.g2sClient?(self, didGetUserData: data!, forPCN: pcn)
            } else {
                self.delegate!.g2sClient?(self, didFailWithError: error!)
            }
        }.resume()
    }
    
    func postUser(data: NSData) {
        let config = configure("users", HTTPMethod: "POST")
        let request = config.request
        request.HTTPBody = data
        
        config.session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error == nil {
                self.delegate!.g2sClient?(self, didPostUserWithResponse: data!)
            } else {
                self.delegate!.g2sClient?(self, didFailWithError: error!)
            }
        }.resume()
    }
    
    func putUser(pcn: String, data: NSData) {
        let config = configure("users/\(pcn)", HTTPMethod: "PUT")
        let request = config.request
        request.HTTPBody = data
        
        config.session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error == nil {
                self.delegate!.g2sClient?(self, didPutUserWithResponse: data!, forPCN: pcn)
            } else {
                self.delegate!.g2sClient?(self, didFailWithError: error!)
            }
        }.resume()
    }
    
    
    // MARK: - Groups
    
    func getGroups() {
        let config = configure("groups", HTTPMethod: "GET")
        
        config.session.dataTaskWithRequest(config.request) { (data, response, error) -> Void in
            if error == nil {
                self.delegate!.g2sClient?(self, didGetGroupsData: data!)
            } else {
                self.delegate!.g2sClient?(self, didFailWithError: error!)
            }
        }.resume()
    }
    
    func postGroup(data: NSData) {
        let config = configure("groups", HTTPMethod: "POST")
        let request = config.request
        request.HTTPBody = data
        
        config.session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error == nil {
                self.delegate!.g2sClient?(self, didPostGroupWithResponse: data!)
            } else {
                self.delegate!.g2sClient?(self, didFailWithError: error!)
            }
        }.resume()
    }
    
    func deleteGroup(id: Int32) {
        let config = configure("groups/\(id)", HTTPMethod: "DELETE")
        
        config.session.dataTaskWithRequest(config.request) { (data, response, error) -> Void in
            if error == nil {
                self.delegate!.g2sClient?(self, didDeleteGroup: id)
            } else {
                self.delegate!.g2sClient?(self, didFailWithError: error!)
            }
        }.resume()
    }
}


// MARK: - Private

private extension G2SClient {
    
    func configure(endpoint: String, HTTPMethod: String) -> (session: NSURLSession, request: NSMutableURLRequest) {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let url = NSURL(string: endpoint, relativeToURL: apiBaseURL)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = HTTPMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return (session, request)
    }
    
}