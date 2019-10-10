
import Foundation
import CPaaSSDK

protocol SMSDelegate {
    func inboundMessageReceived(message: String, senderNumber: String)
    func outboundMessageSent()
    func deliveryStatusChanged()
    func sendMessage(isSuccess: Bool)
}

class SMS_Handler: CPSmsDelegate {
    var cpaas: CPaaS!
    
    var sourceNumber: String!
    var destinationNumber: String!
    
    var authentication: CPAuthenticationService {
        get {
            return self.cpaas.authenticationService
        }
    }
    
    var delegate_SMS:SMSDelegate?
    
    
    init() {
        
    }
    
    // MARK: SmsDelegate methods
    func inboundMessageReceived(message:CPInboundMessage) {
        // save inbound message to the application model
        print(message);
        
        delegate_SMS?.inboundMessageReceived(message: message.parts[0].value(forKey: "text") as! String, senderNumber: message.sender)
    }
    
    func deliveryStatusChanged(status: CPMessageStatus) {
        // update message delivery status in application model
        print(status);
        delegate_SMS?.deliveryStatusChanged()
    }
    
    func outboundMessageSent(message: CPOutboundMessage) {
        // save outbound message to the application model
        print(message);
        
        delegate_SMS?.outboundMessageSent()
    }
    
    func subscribeServices() {
        self.cpaas.smsService!.delegate = self
    }
    
    func sendMessage(message: String) {
        
        if let conversation = self.cpaas.smsService!.createConversation(fromAddress: self.sourceNumber, withParticipant: destinationNumber) {
            let msg = self.cpaas.smsService!.createMessage(withText: message)
            conversation.send(message: msg){
                (error, newMessage) in
                if error != nil {
                    print("SmsService.send failed. destination: \(String(describing: self.destinationNumber)). Error desc:\(error!.description)")
                    self.delegate_SMS?.sendMessage(isSuccess: false)
                    
                } else {
                    print("SMS message sent to \(String(describing: self.destinationNumber))!")
                    // save message to application model
                    self.delegate_SMS?.sendMessage(isSuccess: true)
                }
            }
        }else{
            print("SmsService.send failed.")
            self.delegate_SMS?.sendMessage(isSuccess: false)
        }
    }
}

