//
//  Chat_Handler.swift
//  Ribbon_SDK_Integration
//
//  Created by Rahul on 13/03/19.
//  Copyright © 2019 Ribbon. All rights reserved.
//

import Foundation
import CPaaSSDK

protocol ChatDelegate {
    func inboundMessageReceived(message: String, senderNumber: String)
    func outboundMessageSent()
    func deliveryStatusChanged()
    func sendMessage(isSuccess: Bool)
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
        print(message)
        delegate_CHAT?.inboundMessageReceived(message: message.parts[0].value(forKey: "text") as! String, senderNumber: message.sender)
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
                print(conversations);
            } else {
                // an error occurred
                print("Couldn't fetch conversations: \(error!.localizedDescription)")
            }
        }
    }
    
}

