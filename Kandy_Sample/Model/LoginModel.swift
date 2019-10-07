//
//  LoginModel.swift
//  Medline
//
//  Created by Rajesh Yadav on 24/11/18.
//  Copyright © 2018 RJ. All rights reserved.
//

import UIKit
import SwiftyJSON
import Foundation

class LoginModel: NSObject {
    var clientId:String?
    var emailId:String?
    var password:String?

}


class ProjectLoginModel: NSObject {
    var privateprojectkey:String?
    var privateprojectsecret:String?
}

class AuthenticationModel: Codable,JSONDecodable {
    
    var id_token:String?
    var access_token:String?
    
    required init(json: JSON) {
        
        id_token = json["id_token"].stringValue
        access_token = json["access_token"].stringValue
    }
    
    
    func encode(with aCoder: NSCoder) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
    }
}



public protocol JSONDecodable{
    init(json:JSON)
}

extension Collection where Iterator.Element == JSON {
    func decode<T:JSONDecodable>() -> [T] {
        return map({T(json:$0)})
    }
}

func toData<T: Encodable>(object: T) throws -> Data {
    let encoder = JSONEncoder()
    return try encoder.encode(object)
}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

