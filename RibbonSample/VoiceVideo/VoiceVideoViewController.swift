//
//  ViewController.swift
//  Ribbon_SDK_Integration
//
//  Created by Viviksha on 06/03/19.
//  Copyright © 2019 Ribbon. All rights reserved.
//

import UIKit
import Photos
import CPaaSSDK
import CPCallService
import CallKit


class VoiceVideoViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CallDelegate {
    
    var cpaas: CPaaS!
    var call_Handler = VoiceVideoCall_Handler()
    var currentIncomingCall: CPIncomingCallDelegate!
    var currentOutgoingCall: CPOutgoingCallDelegate!
    
    @IBOutlet weak var txtDestNumber: UITextField!
    @IBOutlet var callButton: UIButton!
    @IBOutlet var audioButton: UIButton!
    @IBOutlet var videoButton: UIButton!
    
    var incomingCallCustomView: IncomingCallCustomView!
    var outgoingCallCustomView: OutgoingCallCustomView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // call
        call_Handler.cpaas = self.cpaas
        call_Handler.subscribeServices()
        call_Handler.delegate_CALL = self
        
        txtDestNumber.placeholder = "[userId]@[domain]"
        txtDestNumber.text = "nesonukuv@nesonukuv.34mv.att.com"
        //txtDestNumber.text = "+12522327784@kandy.pass.5gt3.att.com"

        
        self.setNavigationBarColorForViewController(viewController: self, type: 1, titleString: "CALL")
        
        audioButton.isSelected = true
        
        incomingCallCustomView = Bundle.main.loadNibNamed("IncomingCallCustomView", owner: self, options: nil)?[0] as? IncomingCallCustomView
        incomingCallCustomView.delegateIncomingCall = self
        
        outgoingCallCustomView = Bundle.main.loadNibNamed("OutgoingCallCustomView", owner: self, options: nil)?[0] as? OutgoingCallCustomView
        if(audioButton.isSelected == true) {
        outgoingCallCustomView.isAudioCall = true
        } else {
            outgoingCallCustomView.isAudioCall = false
        }
        outgoingCallCustomView.delegateOutgoingCall = self
        
        app_Delegate?.window?.addSubview(incomingCallCustomView)
        app_Delegate?.window?.addSubview(outgoingCallCustomView)
        
        self.hideIncomingCallView(shouldHide: true)
        self.hideOutgoingCallView(shouldHide: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if incomingCallCustomView != nil {
            incomingCallCustomView.frame = CGRect(x: 0, y: 0, width: (app_Delegate?.window?.frame.width)!, height: (app_Delegate?.window?.frame.height)!)
        }
        
        if outgoingCallCustomView != nil {
            outgoingCallCustomView.frame = CGRect(x: 0, y: 0, width: (app_Delegate?.window?.frame.width)!, height: (app_Delegate?.window?.frame.height)!)
        }
        self.view.layoutIfNeeded()
    }
    
    @IBAction func audioVideoButtonTapped(_ sender: UIButton) {
        if sender.tag == 201 { //Audio
            audioButton.isSelected = true
            videoButton.isSelected = false
            outgoingCallCustomView.isAudioCall = true
        } else { // Video
            audioButton.isSelected = false
            videoButton.isSelected = true
            outgoingCallCustomView.isAudioCall = false
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    
    
    @IBAction func callButtonTapped(_ sender: UIButton) {
        if NetworkState.isConnected() {
            if txtDestNumber.isEmpty(){
                DispatchQueue.main.async { () -> Void in
                    LoaderClass.sharedInstance.hideOverlayView()
                    Alert.instance.showAlert(msg: "Please enter Destination UserId.", title: "", sender: self)
                }
            }else{
                LoaderClass.sharedInstance.showActivityIndicator()
                call_Handler.destinationNumber = txtDestNumber.text
                call_Handler.setOutGoingCall(isVideo:audioButton.isSelected ? false:true)
                print(call_Handler)
            }
        } else{
            DispatchQueue.main.async { () -> Void in
                LoaderClass.sharedInstance.hideOverlayView()
                Alert.instance.showAlert(msg: "No Internet Connection", title: "", sender: self)
            }
        }
    }
}


// Delegate methods from handler

extension VoiceVideoViewController{
    
    func establishCallSucceeded(_ call: CPOutgoingCallDelegate) {
        DispatchQueue.main.async { () -> Void in
            
            if (self.currentOutgoingCall != nil){
                self.currentOutgoingCall = nil
            }

            self.currentOutgoingCall = call
            LoaderClass.sharedInstance.hideOverlayView()
            
            call.localVideoView = self.outgoingCallCustomView.localVideoViewHandler
            call.remoteVideoView = self.outgoingCallCustomView.remoteVideoViewHandler
            
            self.hideIncomingCallView(shouldHide: true)
            self.hideOutgoingCallView(shouldHide: false)
            
        }
    }
    
    func establishCallFailed(_ call: CPOutgoingCallDelegate, withError error: CPError) {
        DispatchQueue.main.async { () -> Void in
            LoaderClass.sharedInstance.hideOverlayView()
            
            //            Alert.instance.showAlert(msg: "Couldn't accept call - \(error.localizedDescription)", title: "", sender: self)
            
            if (self.currentOutgoingCall != nil){
                self.currentOutgoingCall.endCall()
                self.currentOutgoingCall = nil
            }
            
            self.hideIncomingCallView(shouldHide: true)
            self.hideOutgoingCallView(shouldHide: true)
        }
    }
    
    func endCallSucceeded(_ call: CPCallDelegate) {
        DispatchQueue.main.async { () -> Void in
            LoaderClass.sharedInstance.hideOverlayView()
            Alert.instance.showAlert(msg: "Call Ended", title: "", sender: self)

            if (self.currentOutgoingCall != nil){
                self.currentOutgoingCall.endCall()
                self.currentOutgoingCall = nil
            }
            
            if (self.currentIncomingCall != nil){
                self.currentIncomingCall.endCall()
                self.currentIncomingCall = nil
            }
            
            self.hideIncomingCallView(shouldHide: true)
            self.hideOutgoingCallView(shouldHide: true)
        }
    }
    
    func endCallFailed(_ call: CPCallDelegate, withError error: CPError) {
        DispatchQueue.main.async { () -> Void in
            LoaderClass.sharedInstance.hideOverlayView()
            //Alert.instance.showAlert(msg: "Couldn't accept call - \(error.localizedDescription)", title: "", sender: self)
            
            if (self.currentOutgoingCall != nil){
                self.currentOutgoingCall.endCall()
                self.currentOutgoingCall = nil
            }
            
            if (self.currentIncomingCall != nil){
                self.currentIncomingCall.endCall()
                self.currentIncomingCall = nil
            }
            
            
            self.hideIncomingCallView(shouldHide: true)
            self.hideOutgoingCallView(shouldHide: true)
            
        }
    }
    
    
    
    func callStatusChanged(_ call: CPCallDelegate, with callState: CPCallState) {
        print("Call Status changed to state: \(callState.type) for id: \(call.id)")
        DispatchQueue.main.async { () -> Void in
            if callState.type == .ended {
                if (self.currentOutgoingCall != nil){
                    self.currentOutgoingCall.endCall()
                    self.currentOutgoingCall = nil
                }
                
                if (self.currentIncomingCall != nil){
                    self.currentIncomingCall.endCall()
                    self.currentIncomingCall = nil
                }
                
                
                self.hideIncomingCallView(shouldHide: true)
                self.hideOutgoingCallView(shouldHide: true)
            }
            
            if callState.type != .ringing {
            }
            
        }
    }
    
    func incomingCall(_ call: CPIncomingCallDelegate) {
        DispatchQueue.main.async { () -> Void in
            self.currentIncomingCall = call
            self.hideIncomingCallView(shouldHide: false)
            self.hideOutgoingCallView(shouldHide: true)
        }
    }
    
    func acceptCallSucceed(_ call: CPIncomingCallDelegate) {
        DispatchQueue.main.async { () -> Void in
            
            call.localVideoView = self.incomingCallCustomView.localVideoViewHandler
            call.remoteVideoView = self.incomingCallCustomView.remoteVideoViewHandler
            
            self.hideIncomingCallView(shouldHide: false)
            self.hideOutgoingCallView(shouldHide: true)
            
            print("Received Call")
        }
    }
    
    func acceptCallFailed(_ call: CPIncomingCallDelegate, withError error: CPError) {
        
        DispatchQueue.main.async { () -> Void in
            LoaderClass.sharedInstance.hideOverlayView()
            //Alert.instance.showAlert(msg: "Couldn't accept call - \(error.localizedDescription)", title: "", sender: self)
            
            if (self.currentIncomingCall != nil){
                self.currentIncomingCall.endCall()
                self.currentIncomingCall = nil
            }
            
            self.hideIncomingCallView(shouldHide: true)
            self.hideOutgoingCallView(shouldHide: true)
        }
        
    }
    
    func rejectCallSuccedded(_ call: CPIncomingCallDelegate) {
        
        DispatchQueue.main.async { () -> Void in
            
            if (self.currentIncomingCall != nil){
                self.currentIncomingCall.rejectCall()
                self.currentIncomingCall = nil
            }
            
            LoaderClass.sharedInstance.hideOverlayView()
            self.hideIncomingCallView(shouldHide: true)
            self.hideOutgoingCallView(shouldHide: true)
        }
        
    }
    
    func rejectCallFailed(_ call: CPIncomingCallDelegate, withError error: CPError) {
        
        DispatchQueue.main.async { () -> Void in
            self.currentIncomingCall = call
            
            LoaderClass.sharedInstance.hideOverlayView()
            //Alert.instance.showAlert(msg: "Couldn't accept call - \(error.localizedDescription)", title: "", sender: self)
            
            if (self.currentIncomingCall != nil){
                self.currentIncomingCall.endCall()
                self.currentIncomingCall = nil
            }
            
            
            self.hideIncomingCallView(shouldHide: true)
            self.hideOutgoingCallView(shouldHide: true)
        }
    }
    
    func ignoreSucceed(_ call: CPCallDelegate) {
        DispatchQueue.main.async { () -> Void in
            
        }
    }
    
    func ignoreFailed(_ call: CPCallDelegate, withError error: CPError) {
        
        DispatchQueue.main.async { () -> Void in
            LoaderClass.sharedInstance.hideOverlayView()
            //Alert.instance.showAlert(msg: "Couldn't accept call - \(error.localizedDescription)", title: "", sender: self)
            
            if (self.currentOutgoingCall != nil){
                self.currentOutgoingCall.endCall()
                self.currentOutgoingCall = nil
            }
            
            if (self.currentIncomingCall != nil){
                self.currentIncomingCall.endCall()
                self.currentIncomingCall = nil
            }
            
            
            self.hideIncomingCallView(shouldHide: true)
            self.hideOutgoingCallView(shouldHide: true)
        }
    }
    
}

extension VoiceVideoViewController: OutgoingCallDelegate{
    
    // Outgoing Call Delegate For Button Action
    func endOutgoingCallButtonTapped(_ sender: UIButton)
    {
        if (self.currentOutgoingCall != nil){
            self.currentOutgoingCall.endCall()
        }

        self.hideOutgoingCallView(shouldHide: true)
        self.hideOutgoingCallView(shouldHide: true)
    }
}

extension VoiceVideoViewController: IncomingCallDelegate{
    
    // Incoming Call Delegate For Button Action
    func rejectIncomingCallButtonTapped(_ sender: UIButton) {
        
        if (self.currentIncomingCall != nil){
            self.currentIncomingCall.rejectCall()
        }
        
        self.hideIncomingCallView(shouldHide: true)
        self.hideOutgoingCallView(shouldHide: true)
    }
    func answerIncomingWithAudioButtonTapped(_ sender: UIButton) {
        if (self.currentIncomingCall != nil){
            currentIncomingCall.acceptCall(false)
        }
    }
    func answerIncomingWithVideoButtonTapped(_ sender: UIButton) {
        if (self.currentIncomingCall != nil){
            currentIncomingCall.acceptCall(true)
        }
    }
}

extension VoiceVideoViewController{
    
    func hideIncomingCallView(shouldHide:Bool) -> Void {
        if shouldHide {
            app_Delegate?.window?.sendSubviewToBack(self.incomingCallCustomView)
            self.incomingCallCustomView.isHidden = true
        } else {
            self.incomingCallCustomView.isHidden = false
            app_Delegate?.window?.bringSubviewToFront(self.incomingCallCustomView)
        }
    }
    
    func hideOutgoingCallView(shouldHide:Bool) -> Void {
       self.outgoingCallCustomView.showHideView()
        if shouldHide {
            app_Delegate?.window?.sendSubviewToBack(self.outgoingCallCustomView)
            self.outgoingCallCustomView.isHidden = true
        } else {
            self.outgoingCallCustomView.isHidden = false
            app_Delegate?.window?.bringSubviewToFront(self.outgoingCallCustomView)
        }
    }
}






/*
 
 
 //    var authentication: CPAuthenticationService {
 //        get {
 //            return self.cpaas.authenticationService
 //        }
 //    }
 
 //    func getToken(){
 //        let serverUrl = URL(string: serverURL)!
 //        var request : URLRequest = URLRequest(url: serverUrl)
 //        request.httpMethod = "Post"
 //        request.timeoutInterval = 30
 //        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
 //        let bodyData = "client_id=PUB-kandy.j6z8&username=ashishgoel35@gmail.com&password=Test@123&grant_type=password&scope=openid"
 //        request.httpBody = bodyData.data(using: String.Encoding.utf8);
 //
 //        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data,response,error in
 //            if error != nil{
 //                print(error!.localizedDescription)
 //                return
 //            }
 //            if let responseJSON = (try? JSONSerialization.jsonObject(with: data!, options: [])) as? [String:AnyObject]{
 //                self.idToken = responseJSON["id_token"]! as? String
 //                self.accessToken = responseJSON["access_token"]! as? String
 //                self.setToken()
 //            }
 //        })
 //        task.resume()
 //    }
 
 //    func setConfig() {
 //        let configuration = CPConfig.sharedInstance()
 //        configuration.restServerUrl = "oauth-cpaas.att.com"
 //        configuration.useSecureConnection = true
 //    }
 //
 //    func subscribeServices() {
 //        self.cpaas = CPaaS(services:[CPServiceInfo(type: .call, push: true)])
 //        self.cpaas.callService?.setCallApplication(self)
 //    }
 //
 //    func setToken() {
 //        self.authentication.connect(idToken: self.idToken, accessToken: self.accessToken, lifetime: self.lifeTime) { (error, channelInfo) in
 //            if let error = error {
 //                print(error.localizedDescription)
 //            } else {
 //                self.channelInfo = channelInfo!
 //                print("Channel Info " + self.channelInfo)
 //               self.setOutGoingCall()
 //            }
 //        }
 //    }
 //
 //    func setOutGoingCall() {
 //        let service = self.cpaas.callService
 //        let originator = CPUriAddress(username: "ashish8", withDomain: "kandy.j6z8.att.com")
 //        let term = CPUriAddress(username: "ashsih34", withDomain: "kandy.j6z8.att.com")
 //        service?.createOutGoingCall(self, andOriginator: originator, andTerminator: term, completion: { (call, error) in
 //            if let error = error {
 //                print("Call Couldn't be created - Error: \(error.localizedDescription)")
 //                return
 //            }
 //            call?.localVideoView = self.localVideoViewHandler
 //            call?.remoteVideoView = self.remoteVideoViewHandler
 //            call?.establishCall(true)
 //        })
 //    }
 //
 //    func incomingCall(_ call: CPIncomingCallDelegate) {
 //        call.acceptCall(true)
 //        call.localVideoView = self.localVideoViewHandler
 //        call.remoteVideoView = self.remoteVideoViewHandler
 //        print("Received Call")
 //    }
 //
 //    func callStatusChanged(_ call: CPCallDelegate, with callState: CPCallState) {
 //        print("Call status",callState.type)
 //    }
 //
 //    func callAdditionalInfoChanged(_ call: CPCallDelegate, with detailedInfo: [AnyHashable : Any]) {
 //        print("Call Additional InfoChanged",detailedInfo)
 //    }
 //
 //    func mediaAttributesChanged(_ call: CPCallDelegate, with mediaAttributes: CPMediaAttributes) {
 //        print("Media Attributes Changed",mediaAttributes.description)
 //    }
 //
 //    func establishCallSucceeded(_ call: CPOutgoingCallDelegate) {
 //        print("Establish Call Succeeded");
 //    }
 //
 //    func establishCallFailed(_ call: CPOutgoingCallDelegate, withError error: CPError) {
 //        print("Establish Call Failed");
 //    }
 //
 //    func acceptCallSucceed(_ call: CPIncomingCallDelegate) {
 //        print("Accept Call Succeed");
 //    }
 //
 //    func acceptCallFailed(_ call: CPIncomingCallDelegate, withError error: CPError) {
 //        print("Call failed with error ",error.description);
 //    }
 //
 //    func rejectCallSuccedded(_ call: CPIncomingCallDelegate) {
 //        print("Reject Call Succedded");
 //    }
 //
 //    func rejectCallFailed(_ call: CPIncomingCallDelegate, withError error: CPError) {
 //        print("Reject Call Failed");
 //    }
 //
 //    func ignoreSucceed(_ call: CPCallDelegate) {
 //        print("Ignore Succeed");
 //    }
 //
 //    func ignoreFailed(_ call: CPCallDelegate, withError error: CPError) {
 //        print("Ignore Succeed");
 //    }
 //
 //    func endCallSucceeded(_ call: CPCallDelegate) {
 //        print("End Call Succeeded");
 //    }
 //
 //    func endCallFailed(_ call: CPCallDelegate, withError error: CPError) {
 //        print("End Call Failed");
 //    }
 //
 //    func muteCallSucceed(_ call: CPCallDelegate) {
 //        print("Mute Call Succeed");
 //    }
 //
 //    func muteCallFailed(_ call: CPCallDelegate, withError error: CPError) {
 //        print("Mute Call Succeed");
 //    }
 //
 //    func unMuteCallSucceed(_ call: CPCallDelegate) {
 //        print("UnMute Call Succeed");
 //    }
 //
 //    func unMuteCallFailed(_ call: CPCallDelegate, withError error: CPError) {
 //        print("UnMute Call Failed");
 //    }
 //
 //    func videoStartSucceed(_ call: CPCallDelegate) {
 //        print("Video Start Succeed");
 //    }
 //
 //    func videoStartFailed(_ call: CPCallDelegate, withError error: CPError) {
 //        print("Video Start failed");
 //    }
 //
 //    func videoStopSucceed(_ call: CPCallDelegate) {
 //        print("Video Stop Succeed");
 //    }
 //
 //    func videoStopFailed(_ call: CPCallDelegate, withError error: CPError) {
 //        print("Video Stop faled");
 //    }
 //
 //    func holdCallSucceed(_ call: CPCallDelegate) {
 //        print("Hold Call Succeed");
 //    }
 //
 //    func holdCallFailed(_ call: CPCallDelegate, withError error: CPError) {
 //        print("Hold Call Failed");
 //    }
 //
 //    func unHoldCallSucceed(_ call: CPCallDelegate) {
 //        print("UnHold CallSucceed");
 //    }
 //
 //    func unHoldCallFailed(_ call: CPCallDelegate, withError error: CPError) {
 //        print("UnHold CallFailed");
 //    }
 */

