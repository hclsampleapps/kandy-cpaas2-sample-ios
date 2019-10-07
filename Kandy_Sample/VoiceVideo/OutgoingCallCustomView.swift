//
//  OutgoingCallCustomView.swift
//  RibbonSample
//
//  Created by Rajesh Yadav on 06/07/19.
//  Copyright © 2019 RJ. All rights reserved.
//

import UIKit

protocol OutgoingCallDelegate {
    func endOutgoingCallButtonTapped(_ sender: UIButton)
}

class OutgoingCallCustomView: UIView {
    
    @IBOutlet var localVideoViewHandler: UIView!
    @IBOutlet var remoteVideoViewHandler: UIView!
    @IBOutlet weak var lblDestNumber: UILabel!
    @IBOutlet var endCall: UIButton!
    var isAudioCall: Bool = true
    
    var delegateOutgoingCall:OutgoingCallDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func showHideView() {
        if(isAudioCall) {
            self.localVideoViewHandler.isHidden = true;
            self.lblDestNumber.text = "Audio call"
        } else {
            self.localVideoViewHandler.isHidden = false;
            self.lblDestNumber.text = "Video call"
        }
    }
    
    override func layoutSubviews() {
        print("run when UIView appears on screen")
        // you can update your label's text or etc.
    }
    
    @IBAction func endCallButtonTapped(_ sender: UIButton) {
        delegateOutgoingCall?.endOutgoingCallButtonTapped(sender)
    }
}


/*
 let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture))
 localVideoViewHandler.addGestureRecognizer(panGesture)
 
 @objc func panGesture(sender: UIPanGestureRecognizer){
 let point = sender.location(in: view)
 let panGesture = sender.view
 panGesture?.center = point
 print(point)
 }
 */
