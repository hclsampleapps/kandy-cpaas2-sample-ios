import UIKit
import CPaaSSDK

protocol GroupChatDelegate {
    func outboundGroupMessageSent()
    func inboundGroupMessageReceived(message:CPInboundMessage)
}

class GroupChat_handler: CPChatDelegate {
    var cpaas: CPaaS!
    var chatService : CPChatService!
    var groupName : String?
    var userWantsToAccept : Bool!
    var chatGroupsList : CPChatGroup!
    var groupList = [CPChatGroup]()
    var groupId : String!
    var delegate_Group_Chat:GroupChatDelegate?
    
    func subscribeServices() {
        self.cpaas.chatService!.delegate = self
        chatService = self.cpaas.chatService
    }
    
    // Create Group
    func createGroup() {
        let address = "nesonukuv1@nesonukuv.34mv.att.com"
        let isAdmin = true
        let participant = CPChatGroupParticipant(address: address, admin: isAdmin)
        var participants = [CPChatGroupParticipant]()
        participants.append(participant) //Participants array is filled with ChatGroupParticipant objects
        self.chatService?.createChatGroup(name: "Friends2", type:"closed", participants: participants, completion: { (error, chatGroup) in
            print(error.debugDescription)
            if chatGroup != nil {
                self.chatGroupsList = chatGroup
                print(self.chatGroupsList?.name ?? "No group name found")
                print(self.chatGroupsList?.groupID ?? "No group id found")
                if(self.chatGroupsList?.groupID != nil) {
                    self.groupId = (self.chatGroupsList?.groupID!)!
                }
            }
        })
    }
    
    //Get list of groups logged in user part of
    func getGroupsConversationList(handler:@escaping (_ groupListArray:FetchResult?)-> Void){
        self.chatService.fetchGroupConversations { (error, groupList) in
            if(groupList?.result != nil) {
                handler(groupList)
            }
        }
    }
    
    // fetchGroup With GroupId
    func fetchGroupWithgroupId(groupId:String,handler:@escaping (_ groupDetails:CPChatGroup?)-> Void){
        self.chatService.fetchChatGroup(withKey: groupId) { (error, singleChatGroup) in
            if singleChatGroup != nil {
                handler(singleChatGroup)
            }
        }
    }
    
    // fetch Messages of group
    func fetchMessages(count: Int,chatGroup : CPChatGroup,handler:@escaping (_ groupDetails:FetchResult?)-> Void) {
        let conversationObject = self.cpaas.chatService!.createConversation(withGroup: chatGroup)
        let options:FetchOptions = FetchOptions()
        options.max = count
        conversationObject!.fetchMessages(fetchOptions: options) {
            (error, fetchResult) in
            if error == nil {
                handler(fetchResult)
            }
        }
    }
    
    // send message in group
    func sendMessageInGroup(messageToBesend:String,chatGroup : CPChatGroup,handler:@escaping (_ status:Bool?)-> Void){
        if let conversation = self.cpaas.chatService!.createConversation(withGroup: chatGroup) {
            conversation.send(withText: messageToBesend) { (error, message) in
                if(error != nil) {
                    handler(false)
                    print("Error in sending message %@",error!.description)
                } else{
                    handler(true)
                }
            }
        }
    }
    
    //Add participants
    func addParticipants(chatGroup : CPChatGroup,memberAddress:String,memberStatus:Bool,handler:@escaping (_ error:CPError?)-> Void) {
        let address = memberAddress
        let isAdmin = memberStatus
        let participant = CPChatGroupParticipant(address: address, admin: isAdmin)
        chatGroup.add(participant: participant) { (error) in
            if(error != nil) {
                handler(error!)
                print("Error in sending message %@",error!.description)
                } else{
                handler(error)
            }
        }
    }
    
    //Delete participants
    func deleteParticipants(chatGroup : CPChatGroup,member:CPChatGroupParticipant,handler:@escaping (_ error:CPError?)-> Void) {
        chatGroup.remove(participant: member) { (error) in
            if(error != nil) {
                handler(error!)
                print("Error in removeing participant %@",error!.description)
            } else{
                handler(error)
            }
        }
    }

    //Chat delegates
    func inboundMessageReceived(message: CPInboundMessage) {
        delegate_Group_Chat?.inboundGroupMessageReceived(message: message)
    }
    
    func deliveryStatusChanged(status: CPMessageStatus) {
        print("Message recived %@",status)
    }
    
    func outboundMessageSent(message: CPOutboundMessage) {
        delegate_Group_Chat?.outboundGroupMessageSent()
    }
    
    func isComposing(message: CPIsComposingMessage) {
        
    }
    
    func groupInvitationReceived(invitation: CPChatGroupInvitation) {
        self.userWantsToAccept = true
        if (userWantsToAccept) {
            invitation.accept() { error in
                if(error == nil) {
                    print("User accepts the invitation")
                }
            }
        } else {
            invitation.decline() { error in
                print("User decline the invitation")
            }
        }
    }
    
    func groupParticipantStatus(participants: [CPChatGroupParticipant]) {
        print("Status change for participante %@",participants)
    }
    
    func groupChatEnded(groupID: String) {
        print("Group chat ended for group id %@",groupID)
    }
    
}
