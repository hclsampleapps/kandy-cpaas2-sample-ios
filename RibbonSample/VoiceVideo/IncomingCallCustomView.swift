//
//  IncomingCallCustomView.swift
//  RibbonSample
//
//  Created by Rajesh Yadav on 06/07/19.
//  Copyright © 2019 RJ. All rights reserved.
//

import UIKit

protocol IncomingCallDelegate {
    func rejectIncomingCallButtonTapped(_ sender: UIButton)
    func answerIncomingWithAudioButtonTapped(_ sender: UIButton)
    func answerIncomingWithVideoButtonTapped(_ sender: UIButton)
}

class IncomingCallCustomView: UIView {

    @IBOutlet var localVideoViewHandler: UIView!
    @IBOutlet var remoteVideoViewHandler: UIView!
    @IBOutlet weak var lblDestNumber: UILabel!
    @IBOutlet var rejectCall: UIButton!
    @IBOutlet var audioCall: UIButton!
    @IBOutlet var videoCall: UIButton!
    
    var delegateIncomingCall:IncomingCallDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    @IBAction func rejectCallButtonTapped(_ sender: UIButton) {
        delegateIncomingCall?.rejectIncomingCallButtonTapped(sender)
    }
    @IBAction func answerWithAudioButtonTapped(_ sender: UIButton) {
        delegateIncomingCall?.answerIncomingWithAudioButtonTapped(sender)
    }
    @IBAction func answerWithVideoButtonTapped(_ sender: UIButton) {
        delegateIncomingCall?.answerIncomingWithVideoButtonTapped(sender)
    }
}
