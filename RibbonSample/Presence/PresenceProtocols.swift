
import Foundation

@objc protocol PresenceProtocol {
    @objc optional func updateUserStatus(status: String)
    @objc optional func listOfPresenties(list: Any)
    @objc optional func updateUserStatusColor(status : String)
}


