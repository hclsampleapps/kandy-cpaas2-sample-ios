
import UIKit
import SwiftyJSON
import CPaaSSDK

struct ResponsePackage {
    var success = false
    var response: AnyObject? = nil
    var errorMessage: NSString? = nil
}

class UserServiceManager: NSObject {
        
    func loginUserProject(object: ProjectLoginModel,  _ handler:((_ json:JSON?)->Void)?) -> Void {
         let urlString = "https://oauth-cpaas.att.com/cpaas/auth/v1/token"
 
         let url = URL(string: urlString)!
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
         var clientidValue : String
                clientidValue = object.privateprojectkey ?? ""
        
        var clientidSecret : String
                clientidSecret = object.privateprojectsecret ?? ""
        
        var grantTypeValue : String
                grantTypeValue = object.grant_type ?? ""
        
        var scopeTypeValue : String
                scopeTypeValue = object.scope ?? ""
         
         let params = "client_secret=\(clientidSecret)&client_id=\(clientidValue)&grant_type=\(grantTypeValue)&scope=\(scopeTypeValue)"
         request.httpBody = params.data(using: .utf8)

         let task = URLSession.shared.dataTask(with: request) { data, response, error in
             guard let data = data, error == nil else {
                 print("error=\(String(describing: error))")
                 return
             }

             if let httpResponse = response as? HTTPURLResponse {
                 print(httpResponse.statusCode)
                 if(httpResponse.statusCode == 200) {
                     let json = JSON.init(data)
                     handler?(json)
                 } else {
                     handler?(nil)
                 }
                 return
             }
             handler?(nil)
         }
         task.resume()
}
    
    // LOGIN
    func loginUser(object: LoginModel,  _ handler:((_ json:JSON?)->Void)?) -> Void {
        let urlString = "https://oauth-cpaas.att.com/cpaas/auth/v1/token"
        
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        var usernameValue : String
            usernameValue = object.emailId ?? ""
        
        var passwordValue : String
               passwordValue = object.password ?? ""
        
        var clientidValue : String
               clientidValue = object.clientId ?? ""
        
        var grantTypeValue : String
                grantTypeValue = object.grant_type ?? ""
        
        var scopeTypeValue : String
                scopeTypeValue = object.scope ?? ""
        
        let params = "username=\(usernameValue)&password=\(passwordValue)&client_id=\(clientidValue)&grant_type=\(grantTypeValue)&scope=\(scopeTypeValue)"
        request.httpBody = params.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
                if(httpResponse.statusCode == 200) {
                    let json = JSON.init(data)
                    handler?(json)
                } else {
                    handler?(nil)
                }
                return
            }
            handler?(nil)
        }
        task.resume()
    }
}

