//
//  LoaderClass.swift
//  RibbonSample
//
//  Created by Rajesh Yadav on 23/11/18.
//  Copyright © 2018 RJ. All rights reserved.
//

import UIKit

class LoaderClass: NSObject {
    
    internal static let sharedInstance = LoaderClass()
    private override init(){
        
    }
    
    
    private var overlayView = UIView()
    private var activityIndicator = UIActivityIndicatorView()
    
    func showActivityIndicator() -> Void {
        if  let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let window = appDelegate.window {
            overlayView.frame = CGRect(x:0, y:0, width:80, height:80)
            overlayView.center = CGPoint(x: window.frame.width / 2.0, y: window.frame.height / 2.0)
            overlayView.backgroundColor = AppColor.applicationColor
            overlayView.clipsToBounds = true
            overlayView.alpha = 0.5
            overlayView.layer.cornerRadius = 40
            
            activityIndicator.frame = CGRect(x:0, y:0, width:40, height:40)
            activityIndicator.style = .whiteLarge
            activityIndicator.center = CGPoint(x: overlayView.frame.width / 2.0, y: overlayView.frame.height / 2.0)
            
            overlayView.addSubview(activityIndicator)
            window.addSubview(overlayView)
            window.isUserInteractionEnabled = false
            activityIndicator.startAnimating()
        }
    }
    
    func hideOverlayView() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}
