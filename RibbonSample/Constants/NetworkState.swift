//
//  NetworkState.swift
//  RibbonSample
//
//  Created by Rajesh Yadav on 23/11/18.
//  Copyright © 2018 RJ. All rights reserved.
//


import UIKit
import Alamofire

class NetworkState {
    class func isConnected() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
