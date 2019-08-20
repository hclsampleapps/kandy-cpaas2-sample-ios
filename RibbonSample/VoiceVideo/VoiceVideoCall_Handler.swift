//
//  Call_Handler.swift
//  Ribbon_SDK_Integration
//
//  Created by Viviksha on 21/03/19.
//  Copyright © 2019 Ribbon. All rights reserved.
//

import Foundation
import CPaaSSDK
import CPCallService
import CallKit

protocol CallDelegate {
    func establishCallSucceeded(_ call: CPOutgoingCallDelegate)
    func establishCallFailed(_ call: CPOutgoingCallDelegate, withError error: CPError)
    func endCallSucceeded(_ call: CPCallDelegate)
    
    func incomingCall(_ call: CPIncomingCallDelegate)
    func acceptCallSucceed(_ call: CPIncomingCallDelegate)
    func acceptCallFailed(_ call: CPIncomingCallDelegate, withError error: CPError)
    func rejectCallSuccedded(_ call: CPIncomingCallDelegate)
    func rejectCallFailed(_ call: CPIncomingCallDelegate, withError error: CPError)
    
    func ignoreSucceed(_ call: CPCallDelegate)
    func ignoreFailed(_ call: CPCallDelegate, withError error: CPError)
    func endCallFailed(_ call: CPCallDelegate, withError error: CPError)

    func callStatusChanged(_ call: CPCallDelegate, with callState: CPCallState)

}

class VoiceVideoCall_Handler : NSObject,CPCallApplicationDelegate{
    func transferCallSucceed(_ call: CPCallDelegate) {
        
    }
    
    func transferCallFailed(_ call: CPCallDelegate, withError error: CPError) {
        
    }
    
    
    var cpaas: CPaaS!
    var destinationNumber: String!
    
    var authentication: CPAuthenticationService {
        get {
            return self.cpaas.authenticationService
        }
    }
    
    var delegate_CALL:CallDelegate?
    
    override init() {
    }
    func subscribeServices() {
        self.cpaas.callService?.setCallApplication(self)
    }
    
    
    func setOutGoingCall(isVideo: Bool) {
        let service = self.cpaas.callService
        
        let destAddress = destinationNumber.components(separatedBy: "@")
        let destUserId: String = destAddress[0]
        let destDomain: String = destAddress[1]

//        let originator = CPUriAddress(username: "rajesh0530", withDomain: "kandy.pass.5gt3.att.com")
        let term = CPUriAddress(username: destUserId, withDomain: destDomain)
        
        service?.createOutGoingCall(self, andTerminator: term, completion: { (call, error) in
            if let error = error {
                print("Call Couldn't be created - Error: \(error.localizedDescription)")
                return
            }
            call?.establishCall(isVideo)
        })
        
        
//        service?.createOutGoingCall(self, andOriginator: originator, andTerminator: term, completion: { (call, error) in
//            if let error = error {
//                print("Call Couldn't be created - Error: \(error.localizedDescription)")
//                return
//            }
//            call?.establishCall(true)
//        })
    }
    
    func incomingCall(_ call: CPIncomingCallDelegate) {
//        call.acceptCall(false)
        print("Received Call")
        delegate_CALL?.incomingCall(call)
    }
    
    func callStatusChanged(_ call: CPCallDelegate, with callState: CPCallState) {
        print("Call status",callState.type)
        delegate_CALL?.callStatusChanged(call, with: callState)

    }
    
    func callAdditionalInfoChanged(_ call: CPCallDelegate, with detailedInfo: [AnyHashable : Any]) {
        print("Call Additional InfoChanged",detailedInfo)
    }
    
    func mediaAttributesChanged(_ call: CPCallDelegate, with mediaAttributes: CPMediaAttributes) {
        print("Media Attributes Changed",mediaAttributes.description)
    }
    
    func establishCallSucceeded(_ call: CPOutgoingCallDelegate) {
        print("Establish Call Succeeded");
        delegate_CALL?.establishCallSucceeded(call)
    }
    
    func establishCallFailed(_ call: CPOutgoingCallDelegate, withError error: CPError) {
        print("Establish Call Failed");
        delegate_CALL?.establishCallFailed(call, withError: error)
    }
    
    func acceptCallSucceed(_ call: CPIncomingCallDelegate) {
        print("Accept Call Succeed");
        delegate_CALL?.acceptCallSucceed(call)
    }
    
    func acceptCallFailed(_ call: CPIncomingCallDelegate, withError error: CPError) {
        print("Call failed with error ",error.description);
        delegate_CALL?.acceptCallFailed(call, withError: error)
    }
    
    func rejectCallSuccedded(_ call: CPIncomingCallDelegate) {
        print("Reject Call Succedded");
        delegate_CALL?.rejectCallSuccedded(call)
    }
    
    func rejectCallFailed(_ call: CPIncomingCallDelegate, withError error: CPError) {
        print("Reject Call Failed");
        delegate_CALL?.rejectCallFailed(call, withError: error)
    }
    
    func ignoreSucceed(_ call: CPCallDelegate) {
        print("Ignore Succeed");
        delegate_CALL?.ignoreSucceed(call)
    }
    
    func ignoreFailed(_ call: CPCallDelegate, withError error: CPError) {
        print("Ignore Succeed");
        delegate_CALL?.ignoreFailed(call, withError: error)
    }
    
    func endCallSucceeded(_ call: CPCallDelegate) {
        print("End Call Succeeded");
        delegate_CALL?.endCallSucceeded(call)
    }
    
    func endCallFailed(_ call: CPCallDelegate, withError error: CPError) {
        print("End Call Failed");
        delegate_CALL?.endCallFailed(call, withError: error)
    }
    
    func muteCallSucceed(_ call: CPCallDelegate) {
        print("Mute Call Succeed");
    }
    
    func muteCallFailed(_ call: CPCallDelegate, withError error: CPError) {
        print("Mute Call Succeed");
    }
    
    func unMuteCallSucceed(_ call: CPCallDelegate) {
        print("UnMute Call Succeed");
    }
    
    func unMuteCallFailed(_ call: CPCallDelegate, withError error: CPError) {
        print("UnMute Call Failed");
    }
    
    func videoStartSucceed(_ call: CPCallDelegate) {
        print("Video Start Succeed");
    }
    
    func videoStartFailed(_ call: CPCallDelegate, withError error: CPError) {
        print("Video Start failed");
    }
    
    func videoStopSucceed(_ call: CPCallDelegate) {
        print("Video Stop Succeed");
    }
    
    func videoStopFailed(_ call: CPCallDelegate, withError error: CPError) {
        print("Video Stop faled");
    }
    
    func holdCallSucceed(_ call: CPCallDelegate) {
        print("Hold Call Succeed");
    }
    
    func holdCallFailed(_ call: CPCallDelegate, withError error: CPError) {
        print("Hold Call Failed");
    }
    
    func unHoldCallSucceed(_ call: CPCallDelegate) {
        print("UnHold CallSucceed");
    }
    
    func unHoldCallFailed(_ call: CPCallDelegate, withError error: CPError) {
        print("UnHold CallFailed");
    }
    
}
