//
//  UserServiceManager.swift
//  Medline
//
//  Created by Rajesh Yadav on 23/11/18.
//  Copyright © 2018 RJ. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CPaaSSDK

struct ResponsePackage {
    var success = false
    var response: AnyObject? = nil
    var errorMessage: NSString? = nil
}

class UserServiceManager: NSObject {
    
    private var sessionManager = Alamofire.SessionManager()
    
    func loginUserProject(object: ProjectLoginModel,  _ handler:((_ json:JSON?)->Void)?) -> Void {
        let urlString = "https://oauth-cpaas.att.com/cpaas/auth/v1/token"
        
        let parameters: Parameters = [
            "client_id"      : object.privateprojectkey ?? "",
            "client_secret"  : object.privateprojectsecret ?? "",
            "grant_type"     : "client_credentials",
            "scope"          : "openid regular_call",
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
                
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        self.sessionManager = Alamofire.SessionManager(configuration: configuration)
        
        self.sessionManager.request(urlString, method: .post, parameters: parameters,encoding: URLEncoding.default, headers: headers).responseJSON { (dataResponse) in
            
            print("POSTApi statuscode : ",dataResponse.response?.statusCode ?? "")
            self.sessionManager.session.invalidateAndCancel()
            
            guard dataResponse.result.isSuccess else {
                let error = dataResponse.result.error!
                print("POSTApi Error : ",error.localizedDescription)
                handler?(nil)
                return
            }
            if dataResponse.result.value != nil {
                let json = JSON.init(dataResponse.result.value!)
                print(json)
                if dataResponse.response?.statusCode == 200 {
                    handler?(json)
                }
                return
            }
            handler?(nil)
        }
    }

    // LOGIN
    func loginUser(object: LoginModel,  _ handler:((_ json:JSON?)->Void)?) -> Void
    {
        let urlString = "https://oauth-cpaas.att.com/cpaas/auth/v1/token"  //"https://nvs-cpaas-oauth.kandy.io/cpaas/auth/v1/token"
        
        let parameters: Parameters = [
            "client_id"      : object.clientId ?? "",
            "username"       : object.emailId ?? "",
            "password"       : object.password ?? "",
            "grant_type"     : "password",
            "scope"          : "openid",
            ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        self.sessionManager = Alamofire.SessionManager(configuration: configuration)

        self.sessionManager.request(urlString, method: .post, parameters: parameters,encoding: URLEncoding.default, headers: headers).responseJSON { (dataResponse) in
            
            print("POSTApi statuscode : ",dataResponse.response?.statusCode ?? "")
            self.sessionManager.session.invalidateAndCancel()

            guard dataResponse.result.isSuccess else {
                let error = dataResponse.result.error!
                print("POSTApi Error : ",error.localizedDescription)
                handler?(nil)
                return
            }
            if dataResponse.result.value != nil {
                let json = JSON.init(dataResponse.result.value!)
                print(json)
                if dataResponse.response?.statusCode == 200 {
                    handler?(json)
                }
                return
            }
            handler?(nil)
        }
    }
}
