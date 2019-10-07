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
    let serverURL: String = "https://oauth-cpaas.att.com/cpaas/auth/v1/token" //"https://nvs-cpaas-oauth.kandy.io/cpaas/auth/v1/token"
    var service: CPPresenceService?
    var presentitylist: CPPresentityList? = nil
    let contacts = ["nesonukuv@nesonukuv.34mv.att.com"]//["abhishekk@hcl1133.o78s.att.com"]
    var delegate : PresenceProtocol?
    
    // Persense Delegate
    func listChanged(presentityList: CPPresentityList) {
        presentitylist = presentityList
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
        let bodyData = "client_id=PUB-nesonukuv.34mv&username=nesonukuv1@planet-travel.club&password=Test@123&grant_type=password&scope=openid" //"client_id=PUB-hcl1133.o78s&username=guptar@nextemail.net&password=Test@123&grant_type=password&scope= openid"
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
        if UserDefaultsClass.sharedInstance.getIsUserLoggedIn(){
            //self.cpaas.presenceService?.fetchPresenceSource(completion: )
            self.cpaas.presenceService?.fetchPresenceSource {
                (error, presenceSource) in
                if error == nil, let presenceSource = presenceSource {
                    self.updateStatus(statusToUpdate: presenceSource.activity.string)
                    self.delegate?.updateUserStatusColor?(status: presenceSource.activity.string)
                }
                else
                {
                    self.updateStatus(statusToUpdate: CPPresenceActivities.Available.rawValue)
                }
            }
            
        }else {
            self.authentication.connect(idToken: self.idToken, accessToken: self.accessToken, lifetime: self.lifeTime) { (error, channelInfo) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.channelInfo = channelInfo!
                    print("Channel Info " + self.channelInfo)
                    // self.checkPersense()
                    self.updateStatus(statusToUpdate: CPPresenceActivities.Available.rawValue)
                    //    self.fetchAllPresentities()
                }
            }
        }
        
    }
    
    func updateStatus(statusToUpdate: String) {
//        let activityTypesArray = ["Unknown", "Other", "Available", "Away", "Busy", "Lunch", "OnThePhone", "Vacation"]
//        let text = activityTypesArray[7]
        
        let activityType = CPPresenceActivities(rawValue: statusToUpdate)
        var presenceActivity:PresenceActivity!
        presenceActivity = PresenceActivity(activityType)
     
        self.cpaas.presenceService?.createPresenceSource(activity: presenceActivity) {
            (error, newPresenceSource) in
            if error ==  nil {
                print(newPresenceSource?.activity.state.rawValue ?? nil)
                if let updatedStatus = newPresenceSource?.activity.state.rawValue {
                    self.delegate?.updateUserStatus?(status: updatedStatus)
                }
            } else {
                print(error.debugDescription)
            }
        }
     
    }
    
    func checkPersense() {        
        self.cpaas.presenceService?.createPresentityList(name: "default", presentities: self.contacts) {
            (error, newPresentityList) in
            if error == nil {
                self.presentitylist = newPresentityList
                // subscribe for updates to this list
                self.presentitylist?.subscribe { (error) in
                    // don't indicate error to application, just print a log
                    if let error = error {
                        print("Failed to subscribe to presentityList \(self.presentitylist?.name ?? "nil"): \(error.localizedDescription)")
                    }
                }
            } else {
                print("Failed to create presentityList \(self.presentitylist?.name ?? "nil"): \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    /// Fetch all presentities
    func fetchAllPresentities() {
        self.cpaas.presenceService?.fetchAllPresentityLists { (error, presentityLists) in
            if error == nil, let presentityLists = presentityLists, let foundList = presentityLists.first {
                self.presentitylist = foundList
                
                // subscribe for updates to this list
                self.presentitylist?.subscribe { (error) in
                    // don't indicate error to application, just print a log
                    if let error = error {
                        print(error.localizedDescription);
                    }
                }
                
                // Take second step of fetching status for this list
                self.presentitylist?.fetchStatus { (error, presentityStatusList) in
                    //completion(error)
                    print(presentityStatusList?.presentities.count)
                    if let aList = presentityStatusList{
                        self.delegate?.listOfPresenties?(list: aList)
                    }
                    
                }
            } else {
                //completion(error)
                print(error.debugDescription)
            }
        }
    }
}

