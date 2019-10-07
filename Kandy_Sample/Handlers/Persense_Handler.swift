//
//  Persense_Handler.swift
//  Ribbon_SDK_Integration
//
//  Created by Rahul on 14/03/19.
//  Copyright © 2019 Ribbon. All rights reserved.
//

import Foundation
import CPaaSSDK

class Persense_Handler: CPPresenceDelegate {
    
    var cpaas: CPaaS!
    var idToken : String!
    var accessToken : String!
    var lifeTime : Int = 600
    var channelInfo : String!
    let serverURL: String = "https://nvs-cpaas-oauth.kandy.io/cpaas/auth/v1/token"
    var service: CPPresenceService?
    var presentityList: CPPresentityList? = nil
    let contacts = ["abhishekk@hcl1133.o78s.att.com"]
    
    // Persense Delegate
    
    func listChanged(presentityList: CPPresentityList) {
        print(presentityList)
    }
    
    func subscriptionExpired(presentityListHandle: CPPresentityListHandle) {
        print(presentityListHandle)
    }
    
    func statusChanged(presentity: CPPresentity) {
        print(presentity)
    }
    
    var authentication: CPAuthenticationService {
        get {
            return self.cpaas.authenticationService
        }
    }
    
    init() {
        self.subscribeServices()
        self.setConfig()
        self.getToken()
    }
    
    func getToken(){
        let serverUrl = URL(string: serverURL)!
        var request : URLRequest = URLRequest(url: serverUrl)
        request.httpMethod = "Post"
        request.timeoutInterval = 30
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let bodyData = "client_id=PUB-hcl1133.o78s&username=guptar@nextemail.net&password=Test@123&grant_type=password&scope= openid"
        request.httpBody = bodyData.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data,response,error in
            if error != nil{
                print(error!.localizedDescription)
                return
            }
            if let responseJSON = (try? JSONSerialization.jsonObject(with: data!, options: [])) as? [String:AnyObject]{
                self.idToken = responseJSON["id_token"]! as? String
                self.accessToken = responseJSON["access_token"]! as? String
                self.setToken()
            }
        })
        task.resume()
    }
    
    func setConfig() {
        let configuration = CPConfig.sharedInstance()
        configuration.restServerUrl = "oauth-cpaas.att.com"
        configuration.useSecureConnection = true
    }
    
    func subscribeServices() {
        self.cpaas = CPaaS(services:[CPServiceInfo(type: .sms, push: true), CPServiceInfo(type: .chat, push: true),CPServiceInfo(type: .call, push: true), CPServiceInfo(type: .presence, push: false), CPServiceInfo(type: .addressbook, push: false)])
        self.cpaas.presenceService!.delegate = self
    }
    
    func setToken() {
        self.authentication.connect(idToken: self.idToken, accessToken: self.accessToken, lifetime: self.lifeTime) { (error, channelInfo) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.channelInfo = channelInfo!
                print("Channel Info " + self.channelInfo)
               // self.checkPersense()
                self.updateStatus()
            //    self.fetchAllPresentities()
            }
        }
    }
    
    func updateStatus() {
        let activityTypesArray = ["Unknown", "Other", "Available", "Away", "Busy", "Lunch", "OnThePhone", "Vacation"]
        let text = activityTypesArray[7]
        
        let activityType = CPPresenceActivities(rawValue: text)
        var presenceActivity:PresenceActivity!
        presenceActivity = PresenceActivity(activityType)
     
        self.cpaas.presenceService?.createPresenceSource(activity: presenceActivity) {
            (error, newPresenceSource) in
            if error ==  nil {
                print(newPresenceSource?.activity.state.rawValue ?? nil)
            } else {
                print(error.debugDescription)
            }
        }
     
    }
    
    func checkPersense() {        
        self.cpaas.presenceService?.createPresentityList(name: "default", presentities: self.contacts) {
            (error, newPresentityList) in
            if error == nil {
                self.presentityList = newPresentityList
                // subscribe for updates to this list
                self.presentityList?.subscribe { (error) in
                    // don't indicate error to application, just print a log
                    if let error = error {
                        print("Failed to subscribe to presentityList \(self.presentityList?.name ?? "nil"): \(error.localizedDescription)")
                    }
                }
            } else {
                print("Failed to create presentityList \(self.presentityList?.name ?? "nil"): \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    /// Fetch all presentities
    func fetchAllPresentities() {
        self.cpaas.presenceService?.fetchAllPresentityLists { (error, presentityLists) in
            if error == nil, let presentityLists = presentityLists, let foundList = presentityLists.first {
                self.presentityList = foundList
                
                // subscribe for updates to this list
                self.presentityList?.subscribe { (error) in
                    // don't indicate error to application, just print a log
                    if let error = error {
                        print(error.localizedDescription);
                    }
                }
                
                // Take second step of fetching status for this list
                self.presentityList?.fetchStatus { (error, presentityStatusList) in
                    //completion(error)
                    print(presentityStatusList?.presentities.count)
                }
            } else {
                //completion(error)
                print(error.debugDescription)
            }
        }
    }
}

