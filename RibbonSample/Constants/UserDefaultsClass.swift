//
//  UserDefaultsClass.swift
//  RibbonSample
//
//  Created by Rajesh Yadav on 23/11/18.
//  Copyright © 2018 RJ. All rights reserved.
//

import UIKit

class UserDefaultsClass: NSObject {
    
    static let sharedInstance = UserDefaultsClass()
    
    
    /*
     SAVE:
     UserDefaults.standard.set(true, forKey: "Key") //Bool
     UserDefaults.standard.set(1, forKey: "Key")  //Integer
     UserDefaults.standard.set("TEST", forKey: "Key") //setObject
     
     RETRIVE:
     UserDefaults.standard.bool(forKey: "Key")
     UserDefaults.standard.integer(forKey: "Key")
     UserDefaults.standard.string(forKey: "Key")
     
     REMOVE:
     UserDefaults.standard.removeObject(forKey: "Key")
     */
    
    func setIsUserLoggedIn(isLoggedIn: Bool) -> Void {
        UserDefaults.standard.set(true, forKey: "IsUserLoggedIn") //Bool
    }
    
    func getIsUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "IsUserLoggedIn")
    }
    
}
