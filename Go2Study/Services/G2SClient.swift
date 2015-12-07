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

    // MARK: - Constants
    
    private let apiBaseURL = NSURL(string: "http://go2study.lol/api/")
    
    
    // MARK: - Properties
    
    var delegate: G2SClientDelegate?
    
    
    // MARK: - Config
    
    private func getSessionAndRequest(endpoint: String, HTTPMethod: String) -> (session: NSURLSession, request: NSMutableURLRequest) {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        
        let url = NSURL(string: endpoint, relativeToURL: apiBaseURL)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = HTTPMethod
        
        return (session, request)
    }
    
    
    // MARK: - Users
    
    func getUsers() {
        let requestData = getSessionAndRequest("users", HTTPMethod: "GET")
        
        let task = requestData.session.dataTaskWithRequest(requestData.request) { (data, response, error) -> Void in
            if error == nil {
                self.delegate!.g2sClient?(self, didGetUsersData: data!)
            } else {
                self.delegate!.g2sClient?(self, didFailWithError: error!)
            }
        }
        task.resume()
    }
    
    func getUser(pcn: String) {
        let requestData = getSessionAndRequest("users/\(pcn)", HTTPMethod: "GET")
        
        let task = requestData.session.dataTaskWithRequest(requestData.request) { (data, response, error) -> Void in
            if error == nil {
                self.delegate!.g2sClient?(self, didGetUserData: data!, forPCN: pcn)
            } else {
                self.delegate!.g2sClient?(self, didFailWithError: error!)
            }
        }
        task.resume()
    }
    
    func postUser(data: NSData) {
        let requestData = getSessionAndRequest("users", HTTPMethod: "POST")
        let request = requestData.request
        request.HTTPBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = requestData.session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error == nil {
                self.delegate!.g2sClient?(self, didPostUserWithResponse: data!)
            } else {
                self.delegate!.g2sClient?(self, didFailWithError: error!)
            }
        }
        task.resume()
    }
    
    func putUser(pcn: String, data: NSData) {
        let requestData = getSessionAndRequest("users/\(pcn)", HTTPMethod: "PUT")
        let request = requestData.request
        request.HTTPBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = requestData.session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error == nil {
                self.delegate!.g2sClient?(self, didPutUserWithResponse: data!, forPCN: pcn)
            } else {
                self.delegate!.g2sClient?(self, didFailWithError: error!)
            }
        }
        task.resume()
    }
    
    
    // MARK: - Groups
    
    func getGroups() {
        let requestData = getSessionAndRequest("groups", HTTPMethod: "GET")
        
        let task = requestData.session.dataTaskWithRequest(requestData.request) { (data, response, error) -> Void in
            if error == nil {
                self.delegate!.g2sClient?(self, didGetGroupsData: data!)
            } else {
                self.delegate!.g2sClient?(self, didFailWithError: error!)
            }
        }
        task.resume()
    }
    
    func postGroup(data: NSData) {
        let requestData = getSessionAndRequest("groups", HTTPMethod: "POST")
        let request = requestData.request
        request.HTTPBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = requestData.session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error == nil {
                self.delegate!.g2sClient?(self, didPostGroupWithResponse: data!)
            } else {
                self.delegate!.g2sClient?(self, didFailWithError: error!)
            }
        }
        task.resume()
    }
    
    func deleteGroup(id: Int32) {
        let requestData = getSessionAndRequest("groups/\(id)", HTTPMethod: "DELETE")
        
        let task = requestData.session.dataTaskWithRequest(requestData.request) { (data, response, error) -> Void in
            if error == nil {
                self.delegate!.g2sClient?(self, didDeleteGroup: id)
            } else {
                self.delegate!.g2sClient?(self, didFailWithError: error!)
            }
        }
        task.resume()
    }
}
