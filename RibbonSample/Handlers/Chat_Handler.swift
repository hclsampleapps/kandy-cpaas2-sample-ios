import Foundation
import CPaaSSDK

protocol ChatDelegate {
    func inboundMessageReceived(message: String, senderNumber: String)
    func outboundMessageSent()
    func deliveryStatusChanged()
    func sendMessage(isSuccess: Bool)
    func sendMultiMediaMessage(isSuccess: Bool,fileAttachMent : URL,message: String)
    func inboundImageMessageReceived(imageUrl: URL, senderNumber: String)
}

class Chat_Handler : CPChatDelegate {
    
    var cpaas: CPaaS!
    var destinationNumber: String!
    
    var authentication: CPAuthenticationService {
        get {
            return self.cpaas.authenticationService
        }
    }
    
    var delegate_CHAT:ChatDelegate?
    
    init() {
    }
    
    func inboundMessageReceived(message: CPInboundMessage) {
     delegate_CHAT?.inboundMessageReceived(message: message.parts[0].value(forKey: "text") as! String, senderNumber: message.sender)

      if let attachment = message.files.first {
          let localFileUrl = self.getLocalFileName()
          let remoteFileUrl = URL(string: attachment.link)
          self.cpaas.chatService!.download(fromUrl: remoteFileUrl!, toFile: localFileUrl,
              progress: { (bytesReceived, totalBytes) in
                print(bytesReceived)
              },
              completion: { (error, fileUrl) in
                if error != nil {
                    print("ChatService.download failed. Error desc:\(error!.localizedDescription)")
                } else {
                    print("Downloaded attachment to \(String(describing: fileUrl))!")
                    self.delegate_CHAT?.inboundImageMessageReceived(imageUrl: fileUrl!, senderNumber: message.sender)
                }
              }
          )
     }
    }
    
    func getLocalFileName() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func uniqueFileNameWithExtention(fileExtension: String) -> String {
        let uniqueString: String = ProcessInfo.processInfo.globallyUniqueString
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddhhmmsss"
        let dateString: String = formatter.string(from: Date())
        let uniqueName: String = "\(uniqueString)_\(dateString)"
        if fileExtension.count > 0 {
            let fileName: String = "\(uniqueName).\(fileExtension)"
            return fileName
        }
        return uniqueName
    }
    
    func deliveryStatusChanged(status: CPMessageStatus) {
        print(status)
        delegate_CHAT?.deliveryStatusChanged()
    }
    
    func outboundMessageSent(message: CPOutboundMessage) {
        print(message)
        delegate_CHAT?.outboundMessageSent()
    }
    
    func isComposing(message: CPIsComposingMessage) {
        print(message)
    }
    
    func groupInvitationReceived(invitation: CPChatGroupInvitation) {
        print(invitation)
    }
    
    func groupParticipantStatus(participants: [CPChatGroupParticipant]) {
        print(participants)
    }
    
    func groupChatEnded(groupID: String) {
        print(groupID)
    }
    
    func subscribeServices() {
        self.cpaas.chatService!.delegate = self
    }
    
    func sendMessage(message: String) {
        if let conversation = self.cpaas.chatService!.createConversation(withParticipant: self.destinationNumber) {
            conversation.send(withText: message){
                (error, newMessage) in
                if error != nil {
                    print("ChatService.send failed. destination: \(String(describing: self.destinationNumber)). Error desc:\(error!.description)")
                    self.delegate_CHAT?.sendMessage(isSuccess: false)
                    
                } else {
                    print("CHAT message sent to \(String(describing: self.destinationNumber))!")
                    // save message to application model
                    self.delegate_CHAT?.sendMessage(isSuccess: true)
                }
            }
            
        }else{
            print("ChatService.send failed.")
            self.delegate_CHAT?.sendMessage(isSuccess: false)
        }
    }
    
    func fetchConversation() {
        self.cpaas.chatService!.fetchConversations(){
            (error, conversations) -> Void in
            if (error == nil){
                // save conversations to application model
            } else {
                // an error occurred
                print("Couldn't fetch conversations: \(error!.localizedDescription)")
            }
        }
    }
    
    //For multimedia
    func sendMessageWithAttachment(message: String,destinationNumberAddress:String,fileAttachment: URL,handler:@escaping (_ error:CPError?)-> Void) {
        let chatConversationObject = self.cpaas.chatService!.createConversation(withParticipant: destinationNumberAddress) as! CPChatConversation
        chatConversationObject.send(text: message, withFile: fileAttachment, progress: { (value1, value2) in
        }) { (error,outBoundMessage) in
            if(error != nil) {
                self.delegate_CHAT?.sendMultiMediaMessage(isSuccess: false, fileAttachMent:fileAttachment, message: message)
            } else {
                self.delegate_CHAT?.sendMultiMediaMessage(isSuccess: true, fileAttachMent:fileAttachment, message: message)
            }
        }
    }

}

