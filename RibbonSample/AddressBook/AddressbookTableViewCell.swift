//
//  AddressbookTableViewCell.swift
//  RibbonSample
//
//  Created by Rajesh Yadav on 05/04/19.
//  Copyright © 2019 RJ. All rights reserved.
//

import UIKit

class AddressbookTableViewCell: UITableViewCell {
    
    @IBOutlet var imgBg: UIImageView!
    @IBOutlet var txtContactId: UITextField!
    @IBOutlet var txtPrimaryContact: UITextField!
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtBusinessPhoneNumber: UITextField!
    @IBOutlet var txtHomePhoneNumber: UITextField!
    @IBOutlet var imgBuddy: UIImageView!
    @IBOutlet var btnBuddy: UIButton!

    internal func displayContentType(object: AddressbookBO)
    {
        txtContactId.text = object.contactId
        txtPrimaryContact.text = object.primaryContact
        txtFirstName.text = object.firstName
        txtLastName.text = object.lastName
        txtEmail.text = object.email
        txtHomePhoneNumber.text = object.homePhoneNumber
        txtBusinessPhoneNumber.text = object.businessPhoneNumber
        imgBuddy.image = object.isBuddy ? UIImage.init(named: "selected"):UIImage.init(named: "unSelected")
        
        imgBg.layer.borderWidth = 1.0
        imgBg.layer.borderColor = UIColor.lightGray.cgColor
        imgBg.layer.cornerRadius = 4.0
        imgBg.layer.masksToBounds = true
    }
    internal class func height() -> CGFloat {
        return 473
    }
    
    @IBAction func btnBuddyTapped(sender: UIButton){
    }
}
