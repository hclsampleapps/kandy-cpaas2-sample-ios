//
//  PresenceProtocols.swift
//  RibbonSample
//
//  Created by Kunal Nagpal on 15/09/19.
//  Copyright © 2019 RJ. All rights reserved.
//

import Foundation

@objc protocol PresenceProtocol {
    @objc optional func updateUserStatus(status: String)
    @objc optional func listOfPresenties(list: Any)
    @objc optional func updateUserStatusColor(status : String)
}


