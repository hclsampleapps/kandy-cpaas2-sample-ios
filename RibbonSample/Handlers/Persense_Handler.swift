               
import Foundation
import CPaaSSDK

class Persense_Handler: CPPresenceDelegate {
    
    var cpaas: CPaaS!
    var service: CPPresenceService?
    var presentitylist: CPPresentityList? = nil
    let contacts = ["nesonukuv@nesonukuv.34mv.att.com"]
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
    
    func subscribeServices() {
        self.cpaas.presenceService!.delegate = self
    }
    
    func updateStatus(statusToUpdate: String) {
        let activityType = CPPresenceActivities(rawValue: statusToUpdate)
        var presenceActivity:PresenceActivity!
        presenceActivity = PresenceActivity(activityType)
        self.cpaas.presenceService?.createPresenceSource(activity: presenceActivity) {
            (error, newPresenceSource) in
            if error ==  nil {
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

