
import UIKit

class DirectoryBO: NSObject {
     var photoUrl: String!
     var name: String!
     var firstName: String!
     var lastName: String!
     var userId: String!
     var email: String!
     var isBuddy:Bool = false
}

class AddressbookBO: NSObject {
    var contactId: String!
    var primaryContact: String!
    var firstName: String!
    var lastName: String!
    var email: String!
    var homePhoneNumber: String!
    var businessPhoneNumber: String!
    var isBuddy:Bool = false
}
